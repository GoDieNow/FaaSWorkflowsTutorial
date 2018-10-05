#!/bin/bash
#
# The following script cleans your actual install and leaves it as if you have
# just executed the setup.sh script.
#
# Author: Diego Martin (October 2018)
#
################################################################################

echo "Starting refresh..."


# Stoping and  cleaning the system
#
# We stop the minikube and erase all the home directory files in the minikube
# and helm folders.
#
################################################################################

echo "Stoping, killing, and erasing the minikube..."
minikube stop
minikube delete
rm -rf ~/.minikube

echo "Erasing helm..."
rm -rf ~/.helm


echo "Restarting the environment..."


# Starting the engines..
#
# Before the final step we need to start the minikube and initialize helm within
#
################################################################################

echo "Starting the minikube..."
# Minikube
minikube start

echo "Initialising helm..."
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

echo "Adding Fission charts..."
helm repo add fission-charts https://fission.github.io/fission-charts/
helm repo update

echo "Initialising Fission..."
helm install --wait --debug --namespace fission -n fission fission-charts/fission-all --version ${FISSION_VER} --set serviceType=NodePort,routerServiceType=NodePort
sleep 30

echo "Initialising Fission Workflows..."
helm install --wait --debug --namespace fission -n fission-workflows fission-charts/fission-workflows --version ${FISSION_WORKFLOWS_VER}
sleep 30

echo "Setting env variables..."
export FISSION_ROUTER=$(minikube ip):$(kubectl -n fission get svc router -o jsonpath='{...nodePort}')

echo "System refresh done! System ready!"
