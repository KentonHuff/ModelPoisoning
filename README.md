# Model Poisoning Attacks

This code accompanies the paper 'Analyzing Federated Learning through an Adversarial Lens' which has been accepted at ICML 2019. It assumes that the Fashion MNIST data and Census data have been downloaded to /home/data/ on the user's machine.

Dependencies: Tensorflow-1.8, keras, numpy, scipy, scikit-learn

To run federated training with 10 agents and standard averaging based aggregation, use
```
python dist_train_w_attack.py --dataset=fMNIST --k=10 --C=1.0 --E=5 --T=40 --train --model_num=0 --gar=avg
```
To run the basic targeted model poisoning attack, use
```
python dist_train_w_attack.py --dataset=fMNIST --k=10 --C=1.0 --E=5 --T=40 --train --model_num=0 --mal --mal_obj=single --mal_strat=converge --gar=avg
```

To run the alternating minimization attack with distance constraints with the parameters used in the paper, run
```
python dist_train_w_attack.py --dataset=fMNIST --k=10 --C=1.0 --E=5 --T=40 --train --model_num=0 --mal --mal_obj=single --mal_strat=converge_train_alternate_wt_o_dist_self --rho=1e-4 --gar=avg --ls=10 --mal_E=10
```

The function of the various parameters that are set by `utils/globals_vars.py` is given below.

| Parameter   | Function                                               |
|-------------|--------------------------------------------------------|
| --gar       | Gradient Aggregation Rule                              |
| --eta       | Learning Rate                                          |
| --k         | Number of agents                                       |
| --C         | Fraction of agents chosen per time step                |
| --E         | Number of epochs for each agent                        |
| --T         | Total number of iterations                             |
| --B         | Batch size at each agent                               |
| --mal_obj   | Single or multiple targets                             |
| --mal_num   | Number of targets                                      |
| --mal_strat | Strategy to follow                                     |
| --mal_boost | Boosting factor                                        |
| --mal_E     | Number of epochs for malicious agent                   |
| --ls        | Ratio of benign to malicious steps in alt. min. attack |
| --rho       | Weighting factor for distance constraint               |

The other attacks can be found in the file `malicious_agent.py`.

## Logging in to the gpel machines
In order to connect to the GPU machines, you must be on the OU network either in person or via VPN. Instructions for setting up VPN access can be found here: https://www.ou.edu/marcomm/cms/get-started/vpn

Once on the OU network, you can connect to a machine via ssh (PuTTY on windows).

Connection information:

Host Name: gpel[number].cs.nor.ou.edu

Port: 22

Connection Type: SSH

Replace [number] with a number between 8 and 13 inclusive to choose which of the 6 gpel machines to use. I have always used gpel12, and I know that the current settings work on that machine. I'm not sure whether the others have different GPUs or not.

One you connect, log in with your OU 4x4 and password.

## Graduate student lab machine
There is another GPU machine in the graduate student computer lab. This computer's GPU has more memory than the gpel machines, but it has a CUDA compute capability that is too low for the latest versions of TensorFlow. This caused all kinds of problems, and I was unable to get it to work. You could try to get it to work to take advantage of the extra memory and speed up training if you want. You'll have to get someone to set up an account for you on this machine. Egawati Panjei helped me via Dr. Gruenwald.

Connection information:

Host Name: [username]@iverson.cs.nor.ou.edu

Port: 22

Connection Type: SSH

## Setting up the environment
Once logged into a gpel machine install miniconda: https://docs.conda.io/projects/conda/en/latest/user-guide/install/linux.html

Clone your fork of this repo to your local machine. Move the folder data/ one directory up into the directory /home/[4x4]/. Enter the data directory and download the files for the fMNIST dataset into it: https://github.com/zalandoresearch/fashion-mnist/tree/master/data/fashion. Navigate back into the ModelPoisoning Folder.

Then recreate the conda environment with this command:

```
conda env create -f environment.yml
```

Activate the conda environment with
```
conda activate tf
```

## Running Experiments
The shell commands for collecting one repetition of data are in DataCollection.sh. Running this script takes ~1 day. You begin running the script in the background and log out by using the following commands:
```
nohup bash DataCollection.sh &
exit
```
Standard out will be redirected to the file nohup.out. The results (records of performance metrics) will be created in the folder output_files/. The R script for generating the visualizations is in the folder results/. The csvs for that script were created by copying the relevant data points from the files in output_files/.

## Configuration for optimal GPU usage
The GPUs we have access to have a very limited amount of memory. If we provision too much memory, the program crashes. But if we provision too little, the experiments can take unnecessarily long to run. To examine the amount of memory used as you run an experiment, connect with a second ssh/PuTTY window and use the command
```
watch -n 1 nvidia-smi
```
Each agent being trained will appear as a separate thread/process, and you can monitor the total memory usage and the usage of each process.

If your runs are crashing from OOM or you have too much unused memory, there are several parameters you can adjust to fix this:

* Batch size: in global_vars.py adjust the BATCH_SIZE variable for the dataset you are using and adjust the --B flag (see the above table) to match. Reducing the batch size reduces the per agent memory demand.
* max_agents_per_gpu: in global_vars.py adjust the max_agents_per_gpu variable for the dataset you are using. Reducing this reduces the memory demand by training fewer agents on the gpu at one time.

## Reading list
The following are the most important papers that I have encountered to understand this research:

1. McMahan, B., Moore, E., Ramage, D., Hampson, S., & y Arcas, B. A. (2017, April). Communication-efficient learning of deep networks from decentralized data. In Artificial intelligence and statistics (pp. 1273-1282). PMLR.

This introduces the idea of federated learning.

2.  Bhagoji, A. N., Chakraborty, S., Mittal, P., & Calo, S. (2019, May). Analyzing federated learning through an adversarial lens. In International Conference on Machine Learning (pp. 634-643). PMLR.

This introduces the model poisoning attack. This is the paper this code was originally created for at https://github.com/inspire-group/ModelPoisoning

3. Tolpegin, V., Truex, S., Gursoy, M. E., & Liu, L. (2020, September). Data poisoning attacks against federated learning systems. In European Symposium on Research in Computer Security (pp. 480-501). Springer, Cham.

Introduces the PCA defense

4. Li, D., Wong, W. E., Wang, W., Yao, Y., & Chau, M. (2021, August). Detection and mitigation of label-flipping attacks in federated learning systems with KPCA and K-means. In 2021 8th International Conference on Dependable Systems and Their Applications (DSA) (pp. 551-559). IEEE.

Introduced the kPCA defense

5. Awan, S., Luo, B., & Li, F. (2021, October). Contra: Defending against poisoning attacks in federated learning. In European Symposium on Research in Computer Security (pp. 455-475). Springer, Cham.

Introduces the CONTRA defense


