#!/bin/bash
#
# The following script cleans your actual install and leaves it as if you have
# just executed the setup.sh script.
#
# Author: Diego Martin (October 2018)
#
################################################################################


# Colouring
#
# A few variables to compact the colouring of the echos..
#
################################################################################

readonly reset=$(tput sgr0)
readonly alert=$(tput bold; tput setaf 10)


# Versioning
#
# For the ease of seamless reuse of this here we have all the versions numbers
#
################################################################################

FISSION_VER="0.11.0"
FISSION_WORKFLOWS_VER="0.6.0"


echo "$alert > Starting refresh...$reset"


# Stoping and  cleaning the system
#
# We stop the minikube and erase all the home directory files in the minikube
# and helm folders.
#
################################################################################

echo "$alert > Stoping, killing, and erasing the minikube...$reset"
minikube stop
minikube delete
rm -rf ~/.minikube

echo "$alert > Erasing helm...$reset"
rm -rf ~/.helm


echo "$alert > Restarting the environment...$reset"


# Starting the engines..
#
# Before the final step we need to start the minikube and initialize helm within
#
################################################################################

echo "$alert > Starting the minikube...$reset"
# Minikube
minikube start

echo "$alert > Initialising helm...$reset"
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

echo "$alert > Adding Fission charts...$reset"
helm repo add fission-charts https://fission.github.io/fission-charts/
helm repo update

echo "$alert > Initialising Fission...$reset"
helm install --wait --debug --namespace fission -n fission fission-charts/fission-all --version ${FISSION_VER} --set serviceType=NodePort,routerServiceType=NodePort
sleep 30

echo "$alert > Initialising Fission Workflows...$reset"
helm install --wait --debug --namespace fission -n fission-workflows fission-charts/fission-workflows --version ${FISSION_WORKFLOWS_VER}
sleep 30

echo "$alert > Setting env variables...$reset"
export FISSION_ROUTER=$(minikube ip):$(kubectl -n fission get svc router -o jsonpath='{...nodePort}')

echo "$alert > System refresh done! System ready!$reset"
