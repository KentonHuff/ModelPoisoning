#!/bin/bash

python dist_train_w_attack.py --dataset=fMNIST --E=1 --T=20 --train --model_num=0 --mal --mal_obj=single --mal_strat=converge_train_alternate_wt_o_dist_self --rho=1e-4 --gar=contra --ls=10 --mal_E=10 --k=20 --C=0.5 --num_mal=2 --iid=0
python dist_train_w_attack.py --dataset=fMNIST --E=1 --T=20 --train --model_num=0 --mal --mal_obj=single --mal_strat=converge_train_alternate_wt_o_dist_self --rho=1e-4 --gar=pca    --ls=10 --mal_E=10 --k=20 --C=0.5 --num_mal=2 --iid=0
python dist_train_w_attack.py --dataset=fMNIST --E=1 --T=20 --train --model_num=0 --mal --mal_obj=single --mal_strat=converge_train_alternate_wt_o_dist_self --rho=1e-4 --gar=kernel --ls=10 --mal_E=10 --k=20 --C=0.5 --num_mal=2 --iid=0

python dist_train_w_attack.py --dataset=fMNIST --E=1 --T=20 --train --model_num=0 --mal --mal_obj=single --mal_strat=converge_train_alternate_wt_o_dist_self --rho=1e-4 --gar=contra --ls=10 --mal_E=10 --k=20 --C=0.5 --num_mal=2 --iid=0.2
python dist_train_w_attack.py --dataset=fMNIST --E=1 --T=20 --train --model_num=0 --mal --mal_obj=single --mal_strat=converge_train_alternate_wt_o_dist_self --rho=1e-4 --gar=pca    --ls=10 --mal_E=10 --k=20 --C=0.5 --num_mal=2 --iid=0.2
python dist_train_w_attack.py --dataset=fMNIST --E=1 --T=20 --train --model_num=0 --mal --mal_obj=single --mal_strat=converge_train_alternate_wt_o_dist_self --rho=1e-4 --gar=kernel --ls=10 --mal_E=10 --k=20 --C=0.5 --num_mal=2 --iid=0.2

python dist_train_w_attack.py --dataset=fMNIST --E=1 --T=20 --train --model_num=0 --mal --mal_obj=single --mal_strat=converge_train_alternate_wt_o_dist_self --rho=1e-4 --gar=contra --ls=10 --mal_E=10 --k=20 --C=0.5 --num_mal=2 --iid=0.4
python dist_train_w_attack.py --dataset=fMNIST --E=1 --T=20 --train --model_num=0 --mal --mal_obj=single --mal_strat=converge_train_alternate_wt_o_dist_self --rho=1e-4 --gar=pca    --ls=10 --mal_E=10 --k=20 --C=0.5 --num_mal=2 --iid=0.4
python dist_train_w_attack.py --dataset=fMNIST --E=1 --T=20 --train --model_num=0 --mal --mal_obj=single --mal_strat=converge_train_alternate_wt_o_dist_self --rho=1e-4 --gar=kernel --ls=10 --mal_E=10 --k=20 --C=0.5 --num_mal=2 --iid=0.4

python dist_train_w_attack.py --dataset=fMNIST --E=1 --T=20 --train --model_num=0 --mal --mal_obj=single --mal_strat=converge_train_alternate_wt_o_dist_self --rho=1e-4 --gar=contra --ls=10 --mal_E=10 --k=20 --C=0.5 --num_mal=2 --iid=0.6
python dist_train_w_attack.py --dataset=fMNIST --E=1 --T=20 --train --model_num=0 --mal --mal_obj=single --mal_strat=converge_train_alternate_wt_o_dist_self --rho=1e-4 --gar=pca    --ls=10 --mal_E=10 --k=20 --C=0.5 --num_mal=2 --iid=0.6
python dist_train_w_attack.py --dataset=fMNIST --E=1 --T=20 --train --model_num=0 --mal --mal_obj=single --mal_strat=converge_train_alternate_wt_o_dist_self --rho=1e-4 --gar=kernel --ls=10 --mal_E=10 --k=20 --C=0.5 --num_mal=2 --iid=0.6

python dist_train_w_attack.py --dataset=fMNIST --E=1 --T=20 --train --model_num=0 --mal --mal_obj=single --mal_strat=converge_train_alternate_wt_o_dist_self --rho=1e-4 --gar=contra --ls=10 --mal_E=10 --k=20 --C=0.5 --num_mal=2 --iid=0.8
python dist_train_w_attack.py --dataset=fMNIST --E=1 --T=20 --train --model_num=0 --mal --mal_obj=single --mal_strat=converge_train_alternate_wt_o_dist_self --rho=1e-4 --gar=pca    --ls=10 --mal_E=10 --k=20 --C=0.5 --num_mal=2 --iid=0.8
python dist_train_w_attack.py --dataset=fMNIST --E=1 --T=20 --train --model_num=0 --mal --mal_obj=single --mal_strat=converge_train_alternate_wt_o_dist_self --rho=1e-4 --gar=kernel --ls=10 --mal_E=10 --k=20 --C=0.5 --num_mal=2 --iid=0.8

python dist_train_w_attack.py --dataset=fMNIST --E=1 --T=20 --train --model_num=0 --mal --mal_obj=single --mal_strat=converge_train_alternate_wt_o_dist_self --rho=1e-4 --gar=contra --ls=10 --mal_E=10 --k=20 --C=0.5 --num_mal=2 --iid=1.0
python dist_train_w_attack.py --dataset=fMNIST --E=1 --T=20 --train --model_num=0 --mal --mal_obj=single --mal_strat=converge_train_alternate_wt_o_dist_self --rho=1e-4 --gar=pca    --ls=10 --mal_E=10 --k=20 --C=0.5 --num_mal=2 --iid=1.0
python dist_train_w_attack.py --dataset=fMNIST --E=1 --T=20 --train --model_num=0 --mal --mal_obj=single --mal_strat=converge_train_alternate_wt_o_dist_self --rho=1e-4 --gar=kernel --ls=10 --mal_E=10 --k=20 --C=0.5 --num_mal=2 --iid=1.0


python dist_train_w_attack.py --dataset=fMNIST --E=1 --T=20 --train --model_num=0 --mal --mal_obj=single --mal_strat=converge_train_alternate_wt_o_dist_self --rho=1e-4 --gar=contra --ls=10 --mal_E=10 --k=20 --C=0.5 --num_mal=2 --iid=0.4
python dist_train_w_attack.py --dataset=fMNIST --E=1 --T=20 --train --model_num=0 --mal --mal_obj=single --mal_strat=converge_train_alternate_wt_o_dist_self --rho=1e-4 --gar=pca    --ls=10 --mal_E=10 --k=20 --C=0.5 --num_mal=2 --iid=0.4
python dist_train_w_attack.py --dataset=fMNIST --E=1 --T=20 --train --model_num=0 --mal --mal_obj=single --mal_strat=converge_train_alternate_wt_o_dist_self --rho=1e-4 --gar=kernel --ls=10 --mal_E=10 --k=20 --C=0.5 --num_mal=2 --iid=0.4

python dist_train_w_attack.py --dataset=fMNIST --E=1 --T=20 --train --model_num=0 --mal --mal_obj=single --mal_strat=converge_train_alternate_wt_o_dist_self --rho=1e-4 --gar=contra --ls=10 --mal_E=10 --k=20 --C=0.5 --num_mal=6 --iid=0.4
python dist_train_w_attack.py --dataset=fMNIST --E=1 --T=20 --train --model_num=0 --mal --mal_obj=single --mal_strat=converge_train_alternate_wt_o_dist_self --rho=1e-4 --gar=pca    --ls=10 --mal_E=10 --k=20 --C=0.5 --num_mal=6 --iid=0.4
python dist_train_w_attack.py --dataset=fMNIST --E=1 --T=20 --train --model_num=0 --mal --mal_obj=single --mal_strat=converge_train_alternate_wt_o_dist_self --rho=1e-4 --gar=kernel --ls=10 --mal_E=10 --k=20 --C=0.5 --num_mal=6 --iid=0.4

python dist_train_w_attack.py --dataset=fMNIST --E=1 --T=20 --train --model_num=0 --mal --mal_obj=single --mal_strat=converge_train_alternate_wt_o_dist_self --rho=1e-4 --gar=contra --ls=10 --mal_E=10 --k=20 --C=0.5 --num_mal=10 --iid=0.4
python dist_train_w_attack.py --dataset=fMNIST --E=1 --T=20 --train --model_num=0 --mal --mal_obj=single --mal_strat=converge_train_alternate_wt_o_dist_self --rho=1e-4 --gar=pca    --ls=10 --mal_E=10 --k=20 --C=0.5 --num_mal=10 --iid=0.4
python dist_train_w_attack.py --dataset=fMNIST --E=1 --T=20 --train --model_num=0 --mal --mal_obj=single --mal_strat=converge_train_alternate_wt_o_dist_self --rho=1e-4 --gar=kernel --ls=10 --mal_E=10 --k=20 --C=0.5 --num_mal=10 --iid=0.4

python dist_train_w_attack.py --dataset=fMNIST --E=1 --T=20 --train --model_num=0 --mal --mal_obj=single --mal_strat=converge_train_alternate_wt_o_dist_self --rho=1e-4 --gar=contra --ls=10 --mal_E=10 --k=20 --C=0.5 --num_mal=12 --iid=0.4
python dist_train_w_attack.py --dataset=fMNIST --E=1 --T=20 --train --model_num=0 --mal --mal_obj=single --mal_strat=converge_train_alternate_wt_o_dist_self --rho=1e-4 --gar=pca    --ls=10 --mal_E=10 --k=20 --C=0.5 --num_mal=12 --iid=0.4
python dist_train_w_attack.py --dataset=fMNIST --E=1 --T=20 --train --model_num=0 --mal --mal_obj=single --mal_strat=converge_train_alternate_wt_o_dist_self --rho=1e-4 --gar=kernel --ls=10 --mal_E=10 --k=20 --C=0.5 --num_mal=12 --iid=0.4


python dist_train_w_attack.py --dataset=fMNIST --E=1 --T=20 --train --model_num=0 --mal --mal_obj=single --mal_strat=converge_train_alternate_wt_o_dist_self --rho=1e-4 --gar=contra --ls=10 --mal_E=10 --k=10 --C=1 --num_mal=1 --iid=0.4
python dist_train_w_attack.py --dataset=fMNIST --E=1 --T=20 --train --model_num=0 --mal --mal_obj=single --mal_strat=converge_train_alternate_wt_o_dist_self --rho=1e-4 --gar=pca    --ls=10 --mal_E=10 --k=10 --C=1 --num_mal=1 --iid=0.4
python dist_train_w_attack.py --dataset=fMNIST --E=1 --T=20 --train --model_num=0 --mal --mal_obj=single --mal_strat=converge_train_alternate_wt_o_dist_self --rho=1e-4 --gar=kernel --ls=10 --mal_E=10 --k=10 --C=1 --num_mal=1 --iid=0.4

python dist_train_w_attack.py --dataset=fMNIST --E=1 --T=20 --train --model_num=0 --mal --mal_obj=single --mal_strat=converge_train_alternate_wt_o_dist_self --rho=1e-4 --gar=contra --ls=10 --mal_E=10 --k=20 --C=0.5 --num_mal=2 --iid=0.4
python dist_train_w_attack.py --dataset=fMNIST --E=1 --T=20 --train --model_num=0 --mal --mal_obj=single --mal_strat=converge_train_alternate_wt_o_dist_self --rho=1e-4 --gar=pca    --ls=10 --mal_E=10 --k=20 --C=0.5 --num_mal=2 --iid=0.4
python dist_train_w_attack.py --dataset=fMNIST --E=1 --T=20 --train --model_num=0 --mal --mal_obj=single --mal_strat=converge_train_alternate_wt_o_dist_self --rho=1e-4 --gar=kernel --ls=10 --mal_E=10 --k=20 --C=0.5 --num_mal=2 --iid=0.4

python dist_train_w_attack.py --dataset=fMNIST --E=1 --T=20 --train --model_num=0 --mal --mal_obj=single --mal_strat=converge_train_alternate_wt_o_dist_self --rho=1e-4 --gar=contra --ls=10 --mal_E=10 --k=50 --C=0.2 --num_mal=5 --iid=0.4
python dist_train_w_attack.py --dataset=fMNIST --E=1 --T=20 --train --model_num=0 --mal --mal_obj=single --mal_strat=converge_train_alternate_wt_o_dist_self --rho=1e-4 --gar=pca    --ls=10 --mal_E=10 --k=50 --C=0.2 --num_mal=5 --iid=0.4
python dist_train_w_attack.py --dataset=fMNIST --E=1 --T=20 --train --model_num=0 --mal --mal_obj=single --mal_strat=converge_train_alternate_wt_o_dist_self --rho=1e-4 --gar=kernel --ls=10 --mal_E=10 --k=50 --C=0.2 --num_mal=5 --iid=0.4

python dist_train_w_attack.py --dataset=fMNIST --E=1 --T=20 --train --model_num=0 --mal --mal_obj=single --mal_strat=converge_train_alternate_wt_o_dist_self --rho=1e-4 --gar=contra --ls=10 --mal_E=10 --k=80 --C=0.125 --num_mal=8 --iid=0.4
python dist_train_w_attack.py --dataset=fMNIST --E=1 --T=20 --train --model_num=0 --mal --mal_obj=single --mal_strat=converge_train_alternate_wt_o_dist_self --rho=1e-4 --gar=pca    --ls=10 --mal_E=10 --k=80 --C=0.125 --num_mal=8 --iid=0.4
python dist_train_w_attack.py --dataset=fMNIST --E=1 --T=20 --train --model_num=0 --mal --mal_obj=single --mal_strat=converge_train_alternate_wt_o_dist_self --rho=1e-4 --gar=kernel --ls=10 --mal_E=10 --k=80 --C=0.125 --num_mal=8 --iid=0.4

python dist_train_w_attack.py --dataset=fMNIST --E=1 --T=20 --train --model_num=0 --mal --mal_obj=single --mal_strat=converge_train_alternate_wt_o_dist_self --rho=1e-4 --gar=contra --ls=10 --mal_E=10 --k=100 --C=0.1 --num_mal=10 --iid=0.4
python dist_train_w_attack.py --dataset=fMNIST --E=1 --T=20 --train --model_num=0 --mal --mal_obj=single --mal_strat=converge_train_alternate_wt_o_dist_self --rho=1e-4 --gar=pca    --ls=10 --mal_E=10 --k=100 --C=0.1 --num_mal=10 --iid=0.4
python dist_train_w_attack.py --dataset=fMNIST --E=1 --T=20 --train --model_num=0 --mal --mal_obj=single --mal_strat=converge_train_alternate_wt_o_dist_self --rho=1e-4 --gar=kernel --ls=10 --mal_E=10 --k=100 --C=0.1 --num_mal=10 --iid=0.4
