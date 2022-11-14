#########################
# Purpose: Main function to perform federated training and all model poisoning attacks
########################
import warnings

warnings.filterwarnings("ignore")
import os

os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2'
os.environ["CUDA_DEVICE_ORDER"] = "PCI_BUS_ID"
os.environ["CUDA_VISIBLE_DEVICES"] = "0"
import numpy as np
import tensorflow.compat.v1 as tf
tf.disable_v2_behavior()

import logging
tf.get_logger().setLevel(logging.ERROR)

from multiprocessing import Process, Manager
from sklearn.metrics.pairwise import cosine_similarity
from sklearn.decomposition import PCA
from sklearn.decomposition import KernelPCA
from sklearn.cluster import KMeans
from utils.io_utils import data_setup, mal_data_setup
import global_vars as gv
from agents import agent, master
from utils.eval_utils import eval_func, eval_minimal
from malicious_agent import mal_agent
from utils.dist_utils import collate_weights, model_shape_size
from math import log


def train_fn(X_train_shards, Y_train_shards, X_test, Y_test, return_dict,
			 mal_data_X=None, mal_data_Y=None):
	# Start the training process
	num_agents_per_time = int(args.C * args.k)
	simul_agents = gv.num_gpus * gv.max_agents_per_gpu
	simul_num = min(num_agents_per_time, simul_agents)
	alpha_i = 1.0 / args.k
	agent_indices = np.arange(args.k)
	if args.mal:
		mal_agent_index = gv.mal_agent_index

	unupated_frac = (args.k - num_agents_per_time) / float(args.k)
	t = 0
	mal_visible = []
	eval_loss_list = []
	loss_track_list = []
	lr = args.eta
	loss_count = 0
	E = None
	beta = 0.5
	param_dict = dict()
	param_dict['offset'] = [0]
	param_dict['shape'] = []
	if args.gar == 'krum':
		krum_select_indices = []
	
	G = [None for i in range(0,args.k)]
	r = [1 for i in range(0,args.k)]
	Delta = 0.1

	while t < args.T:
	# while return_dict['eval_success'] < gv.max_acc and t < args.T:
		print('Time step %s' % t)
		
		lmbda = args.C*(1-args.C)
		probs = [args.C + lmbda*ri for ri in r]
		probs_sum = sum(probs)
		probs = [elem/probs_sum for elem in probs]

		process_list = []
		mal_active = 0
		curr_agents = np.random.choice(agent_indices, num_agents_per_time,
									   replace=False,p=probs)
		print('Set of agents chosen: %s' % curr_agents)

		k = 0
		agents_left = 1e4
		while k < num_agents_per_time:
			true_simul = min(simul_num, agents_left)
			print('training %s agents' % true_simul)
			for l in range(true_simul):
				gpu_index = int(l / gv.max_agents_per_gpu)
				gpu_id = gv.gpu_ids[gpu_index]
				i = curr_agents[k]
				if args.mal is False or i < mal_agent_index:
					p = Process(target=agent, args=(i, X_train_shards[i],
													Y_train_shards[i], t, gpu_id, return_dict, X_test, Y_test, lr))
				elif args.mal is True and i >= mal_agent_index:
					p = Process(target=mal_agent, args=(X_train_shards[i],
														Y_train_shards[i], mal_data_X, mal_data_Y, t,
														gpu_id, return_dict, mal_visible, X_test, Y_test))
					mal_active = 1

				p.start()
				process_list.append(p)
				k += 1
			for item in process_list:
				item.join()
			agents_left = num_agents_per_time - k
			print('Agents left:%s' % agents_left)

		if mal_active == 1:
			mal_visible.append(t)

		print('Joined all processes for time step %s' % t)

		global_weights = np.load(gv.dir_name + 'global_weights_t%s.npy' % t, allow_pickle=True)
		
		if 'contra' in args.gar:
			update_mat = np.hstack([i.ravel() for i in return_dict[str(curr_agents[0])]])
			for k in range(1,num_agents_per_time):
				#print(return_dict[str(curr_agents[k])].flatten())
				update_mat = np.vstack((update_mat,np.hstack([i.ravel() for i in return_dict[str(curr_agents[k])]])))
			print('Using CONTRA for aggregation')
			cs = [[0 for i in range(num_agents_per_time)] for i in range(num_agents_per_time)]
			tau = [0 for i in range(num_agents_per_time)]
			for k in range(num_agents_per_time):
				if G[curr_agents[k]] is None:
					G[curr_agents[k]] = update_mat[k,:]
					#print('Initialized!')
					#print(np.divide(G[curr_agents[k]],np.linalg.norm(G[curr_agents[k]])))
				else:
					G[curr_agents[k]] += update_mat[k,:]
					#print(type(np.divide(G[curr_agents[k]],np.linalg.norm(G[curr_agents[k]]))))
			for k in range(num_agents_per_time):				
				for z in range(num_agents_per_time):
					if z != k:
						cs[k][z] = np.dot(np.divide(G[curr_agents[k]],np.linalg.norm(G[curr_agents[k]])),G[curr_agents[z]]/np.linalg.norm(G[curr_agents[z]]))
				tau[k] = max(cs[k])
				print('tau:',tau[k])
				threshold=0
				Delta = 0.1
				if tau[k] > threshold:
					r[curr_agents[k]] -= Delta
				else:
					r[curr_agents[k]] += Delta
			learning_rates = [0 for i in range(num_agents_per_time)]
			for m in range(num_agents_per_time):
				for n in range(num_agents_per_time):
					cs[m][n] *= min([1,tau[m]/tau[n]])
				learning_rates[m] = 1-tau[m]
				print('initial lr:',learning_rates[m])
				r[m] = r[m]/max(r)
			learning_rates_max = max(learning_rates)
			for m in range(num_agents_per_time):
				learning_rates[m] = learning_rates[m]/learning_rates_max
				#print('normalized lr:',learning_rates[m])
				#if learning_rates[m] != 0.0:
				#	learning_rates[m] = log(learning_rates[m]/(1-learning_rates[m]),2)+0.5
				#print('diverged lr:',learning_rates[m])
			learning_rates_sum = sum(learning_rates)
			for m in range(num_agents_per_time):
				learning_rates[m] = learning_rates[m]/learning_rates_sum * alpha_i*num_agents_per_time
				#print('final lr:',learning_rates[m])
			#print('sum:',sum(learning_rates))
			for k in range(num_agents_per_time):
				global_weights += learning_rates[k] * return_dict[str(curr_agents[k])]
				#global_weights += alpha_i * return_dict[str(curr_agents[k])]
			

		elif 'avg' in args.gar:
			print('Using standard mean aggregation')
			if args.mal:
				count = 0
				for k in range(num_agents_per_time):
					if curr_agents[k] != mal_agent_index:
						if count == 0:
							ben_delta = alpha_i * return_dict[str(curr_agents[k])]
							np.save(gv.dir_name + 'ben_delta_sample%s.npy' % t, return_dict[str(curr_agents[k])])
							count += 1
						else:
							ben_delta += alpha_i * return_dict[str(curr_agents[k])]

				np.save(gv.dir_name + 'ben_delta_t%s.npy' % t, ben_delta)
				global_weights += alpha_i * return_dict[str(mal_agent_index)]
				global_weights += ben_delta
			else:
				for k in range(num_agents_per_time):
					global_weights += alpha_i * return_dict[str(curr_agents[k])]
		
		elif 'pca' in args.gar:
			print('Using PCA+Clustering')
			#print(return_dict[str(curr_agents[0])].shape)
			update_mat = np.hstack([i.ravel() for i in return_dict[str(curr_agents[0])]])
			#print(update_mat)
			for k in range(1,num_agents_per_time):
				#print(return_dict[str(curr_agents[k])].flatten())
				update_mat = np.vstack((update_mat,np.hstack([i.ravel() for i in return_dict[str(curr_agents[k])]])))
			#print(update_mat)
			reduced = PCA(n_components=2).fit_transform(update_mat)
			kmeans = KMeans(n_clusters=2).fit(reduced)
			print(kmeans.labels_)
			if sum(kmeans.labels_) < num_agents_per_time/2:
				if kmeans.labels_[list(curr_agents).index(mal_agent_index)] == 1:
					print("EXCLUDED MAL AGENT")
				else:
					print("FAILED TO EXCLUDE MAL AGENT")
				for k in range(num_agents_per_time):
					if kmeans.labels_[k] != 1:
						global_weights += alpha_i * return_dict[str(curr_agents[k])]
			else:
				if kmeans.labels_[list(curr_agents).index(mal_agent_index)] == 0:
					print("EXCLUDED MAL AGENT")
				else:
					print("FAILED TO EXCLUDE MAL AGENT")
				for k in range(num_agents_per_time):
					if kmeans.labels_[k] == 1:
						global_weights += alpha_i * return_dict[str(curr_agents[k])]
			print("SIZE OF EXCLUDED GROUP:",min([sum(kmeans.labels_),num_agents_per_time-sum(kmeans.labels_)]))
		
		elif 'kernel' in args.gar:
			print('Using KPCA+Clustering')
			#print(return_dict[str(curr_agents[0])].shape)
			update_mat = np.hstack([i.ravel() for i in return_dict[str(curr_agents[0])]])
			#print(update_mat)
			for k in range(1,num_agents_per_time):
				#print(return_dict[str(curr_agents[k])].flatten())
				update_mat = np.vstack((update_mat,np.hstack([i.ravel() for i in return_dict[str(curr_agents[k])]])))
			#print(update_mat)
			reduced = KernelPCA(n_components=2).fit_transform(update_mat)
			kmeans = KMeans(n_clusters=2).fit(reduced)
			print(kmeans.labels_)
			if sum(kmeans.labels_) < num_agents_per_time/2:
				if kmeans.labels_[list(curr_agents).index(mal_agent_index)] == 1:
					print("EXCLUDED MAL AGENT")
				else:
					print("FAILED TO EXCLUDE MAL AGENT")
				for k in range(num_agents_per_time):
					if kmeans.labels_[k] != 1:
						global_weights += alpha_i * return_dict[str(curr_agents[k])]
			else:
				if kmeans.labels_[list(curr_agents).index(mal_agent_index)] == 0:
					print("EXCLUDED MAL AGENT")
				else:
					print("FAILED TO EXCLUDE MAL AGENT")
				for k in range(num_agents_per_time):
					if kmeans.labels_[k] == 1:
						global_weights += alpha_i * return_dict[str(curr_agents[k])]
			print("SIZE OF EXCLUDED GROUP:",min([sum(kmeans.labels_),num_agents_per_time-sum(kmeans.labels_)]))
			
		
		elif 'krum' in args.gar:
			print('Using krum for aggregation')
			collated_weights = []
			collated_bias = []
			agg_num = int(num_agents_per_time - 1 - 2)
			for k in range(num_agents_per_time):
				# weights_curr, bias_curr = collate_weights(return_dict[str(curr_agents[k])])
				weights_curr, bias_curr = collate_weights(return_dict[str(k)])
				collated_weights.append(weights_curr)
				collated_bias.append(collated_bias)
			score_array = np.zeros(num_agents_per_time)
			for k in range(num_agents_per_time):
				dists = []
				for i in range(num_agents_per_time):
					if i == k:
						continue
					else:
						dists.append(np.linalg.norm(collated_weights[k] - collated_weights[i]))
				dists = np.sort(np.array(dists))
				dists_subset = dists[:agg_num]
				score_array[k] = np.sum(dists_subset)
			print(score_array)
			krum_index = np.argmin(score_array)
			print(krum_index)
			global_weights += return_dict[str(krum_index)]
			if krum_index == mal_agent_index:
				krum_select_indices.append(t)
		elif 'coomed' in args.gar:
			print('Using coordinate-wise median for aggregation')
			# Fix for mean aggregation first!
			weight_tuple_0 = return_dict[str(curr_agents[0])]
			weights_0, bias_0 = collate_weights(weight_tuple_0)
			weights_array = np.zeros((num_agents_per_time, len(weights_0)))
			bias_array = np.zeros((num_agents_per_time, len(bias_0)))
			# collated_weights = []
			# collated_bias = []
			for k in range(num_agents_per_time):
				weight_tuple = return_dict[str(curr_agents[k])]
				weights_curr, bias_curr = collate_weights(weight_tuple)
				weights_array[k, :] = weights_curr
				bias_array[k, :] = bias_curr
			shape_size = model_shape_size(weight_tuple)
			# weights_array = np.reshape(np.array(collated_weights),(len(weights_curr),num_agents_per_time))
			# bias_array = np.reshape(np.array(collated_bias),(len(bias_curr),num_agents_per_time))
			med_weights = np.median(weights_array, axis=0)
			med_bias = np.median(bias_array, axis=0)
			num_layers = len(shape_size[0])
			update_list = []
			w_count = 0
			b_count = 0
			for i in range(num_layers):
				weights_length = shape_size[2][i]
				update_list.append(med_weights[w_count:w_count + weights_length].reshape(shape_size[0][i]))
				w_count += weights_length
				bias_length = shape_size[3][i]
				update_list.append(med_bias[b_count:b_count + bias_length].reshape(shape_size[1][i]))
				b_count += bias_length
			assert model_shape_size(update_list) == shape_size
			global_weights += update_list

		# Saving for the next update
		np.save(gv.dir_name + 'global_weights_t%s.npy' %
				(t + 1), global_weights)

		# Evaluate global weight
		if args.mal:
			p_eval = Process(target=eval_func, args=(
				X_test, Y_test, t + 1, return_dict, mal_data_X, mal_data_Y), kwargs={'global_weights': global_weights})
		else:
			p_eval = Process(target=eval_func, args=(
				X_test, Y_test, t + 1, return_dict), kwargs={'global_weights': global_weights})
		p_eval.start()
		p_eval.join()

		eval_loss_list.append(return_dict['eval_loss'])

		t += 1

	return t


def main(args):
	X_train, Y_train, X_test, Y_test, Y_test_uncat = data_setup()

	# Create data shards
	random_indices = np.random.choice(
		len(X_train), len(X_train), replace=False)
	X_train_permuted = X_train[random_indices]
	Y_train_permuted = Y_train[random_indices]
	X_train_shards = np.split(X_train_permuted, args.k)
	Y_train_shards = np.split(Y_train_permuted, args.k)

	if args.mal:
		# Load malicious data
		mal_data_X, mal_data_Y, true_labels = mal_data_setup(X_test, Y_test, Y_test_uncat)

	if args.train:
		p = Process(target=master)
		p.start()
		p.join()

		manager = Manager()
		return_dict = manager.dict()
		return_dict['eval_success'] = 0.0
		return_dict['eval_loss'] = 0.0

		if args.mal:
			return_dict['mal_suc_count'] = 0
			t_final = train_fn(X_train_shards, Y_train_shards, X_test, Y_test_uncat,
							   return_dict, mal_data_X, mal_data_Y)
			print('Malicious agent succeeded in %s of %s iterations' %
				  (return_dict['mal_suc_count'], t_final * args.mal_num))
		else:
			_ = train_fn(X_train_shards, Y_train_shards, X_test, Y_test_uncat,
						 return_dict)
	else:
		manager = Manager()
		return_dict = manager.dict()
		return_dict['eval_success'] = 0.0
		return_dict['eval_loss'] = 0.0
		if args.mal:
			return_dict['mal_suc_count'] = 0
		for t in range(args.T):
			if not os.path.exists(gv.dir_name + 'global_weights_t%s.npy' % t):
				print('No directory found for iteration %s' % t)
				break
			if args.mal:
				p_eval = Process(target=eval_func, args=(
					X_test, Y_test_uncat, t, return_dict, mal_data_X, mal_data_Y))
			else:
				p_eval = Process(target=eval_func, args=(
					X_test, Y_test_uncat, t, return_dict))

			p_eval.start()
			p_eval.join()

		if args.mal:
			print('Malicious agent succeeded in %s of %s iterations' %
				  (return_dict['mal_suc_count'], (t - 1) * args.mal_num))


if __name__ == "__main__":
	args = gv.init()
	tf.set_random_seed(777)
	np.random.seed(777)
	main(args)
