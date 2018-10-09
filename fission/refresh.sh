#!/bin/bash
#
# The following script cleans your actual install and leaves it as if you have
# just executed the setup.sh script.
#
# Author: Diego Martin (October 2018)
#
################################################################################


# Versioning
#
# For the ease of seamless reuse of this here we have all the versions numbers
#
################################################################################

FISSION_VER="0.11.0"
FISSION_WORKFLOWS_VER="0.5.0"


echo "$(tput setaf 1)Starting refresh...$(tput sgr 0)"


# Stoping and  cleaning the system
#
# We stop the minikube and erase all the home directory files in the minikube
# and helm folders.
#
################################################################################

echo "$(tput setaf 1)Stoping, killing, and erasing the minikube...$(tput sgr 0)"
minikube stop
minikube delete
rm -rf ~/.minikube

echo "$(tput setaf 1)Erasing helm...$(tput sgr 0)"
rm -rf ~/.helm


echo "$(tput setaf 1)Restarting the environment...$(tput sgr 0)"


# Starting the engines..
#
# Before the final step we need to start the minikube and initialize helm within
#
################################################################################

echo "$(tput setaf 1)Starting the minikube...$(tput sgr 0)"
# Minikube
minikube start

echo "$(tput setaf 1)Initialising helm...$(tput sgr 0)"
# Helm
helm init

# Waiting for tiller to be ready
while :
do
    a=$(kubectl -n kube-system get po | grep tiller | awk '{ print $2; }')

    if [ "$a" == "1/1" ]
    then
        break;
    fi

    sleep 5;
done


# Fission installation
#
# Now, using Helm we will install fission and fission workflows themselves in
# the minikube environment.
# We will also export the env variable $FISSION_ROUTER which will contain the
# ip:port tupla for later use.
#
################################################################################

echo "$(tput setaf 1)Adding Fission charts...$(tput sgr 0)"
helm repo add fission-charts https://fission.github.io/fission-charts/
helm repo update

echo "$(tput setaf 1)Initialising Fission...$(tput sgr 0)"
helm install --wait --debug --namespace fission -n fission fission-charts/fission-all --version ${FISSION_VER} --set serviceType=NodePort,routerServiceType=NodePort
sleep 30

echo "$(tput setaf 1)Initialising Fission Workflows...$(tput sgr 0)"
helm install --wait --debug --namespace fission -n fission-workflows fission-charts/fission-workflows --version ${FISSION_WORKFLOWS_VER}
sleep 30

echo "$(tput setaf 1)Setting env variables...$(tput sgr 0)"
export FISSION_ROUTER=$(minikube ip):$(kubectl -n fission get svc router -o jsonpath='{...nodePort}')

echo "$(tput setaf 1)System refresh done! System ready!$(tput sgr 0)"
