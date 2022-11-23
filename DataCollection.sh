#!/bin/bash

python dist_train_w_attack.py --dataset=fMNIST --k=5 --C=1.0 --E=1 --T=40 --train --model_num=0 --gar=avg --B=100
python dist_train_w_attack.py --dataset=fMNIST --k=5 --C=1.0 --E=1 --T=40 --train --model_num=0 --gar=avg --B=100
python dist_train_w_attack.py --dataset=fMNIST --k=5 --C=1.0 --E=1 --T=40 --train --model_num=0 --gar=avg --B=100

python dist_train_w_attack.py --dataset=fMNIST --k=10 --C=1.0 --E=1 --T=40 --train --model_num=0 --gar=avg --B=100
python dist_train_w_attack.py --dataset=fMNIST --k=10 --C=1.0 --E=1 --T=40 --train --model_num=0 --gar=avg --B=100
python dist_train_w_attack.py --dataset=fMNIST --k=10 --C=1.0 --E=1 --T=40 --train --model_num=0 --gar=avg --B=100

python dist_train_w_attack.py --dataset=fMNIST --k=100 --C=0.1 --E=1 --T=40 --train --model_num=0 --gar=avg --B=100
python dist_train_w_attack.py --dataset=fMNIST --k=100 --C=0.1 --E=1 --T=40 --train --model_num=0 --gar=avg --B=100
python dist_train_w_attack.py --dataset=fMNIST --k=100 --C=0.1 --E=1 --T=40 --train --model_num=0 --gar=avg --B=100


python dist_train_w_attack.py --dataset=CIFAR-10 --k=5 --C=1.0 --E=1 --T=40 --train --model_num=0 --gar=avg --B=100
