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

Host Name: gpel12.cs.nor.ou.edu

Port: 22

Connection Type: SSH

One you connect, log in with your OU 4x4 and password.

## Graduate student lab machine
There is another GPU machine in the graduate student computer lab. This computer's GPU has more memory than the gpel machines, but it has a CUDA compute capability that is too low for the latest versions of TensorFlow. This caused all kinds of problems, and I was unable to get it to work. You could try to get it to work to take advantage of the extra memory and speed up training if you want. You'll have to get someone to set up an account for you on this machine. Egawati Panjei helped me via Dr. Gruenwald.

Connection information:

Host Name: [username]@iverson.cs.nor.ou.edu

Port: 22

Connection Type: SSH

## Setting up the environment
Once logged into a gpel machine install miniconda: https://docs.conda.io/projects/conda/en/latest/user-guide/install/linux.html

Clone your fork of this repo to your local machine. Navigate into the ModelPoisoning Folder

Then recreate the conda environment with this command:

```
conda env create -f environment.yml
```

Activate the conda environment with
```
conda activate tf
```
