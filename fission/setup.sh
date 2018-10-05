#!/bin/bash
#
# The following script gets your system ready to use Fission and
# Fission workflows.
#
# The setup includes the install of: kubectl, minikube, helm, fission and
# fission-workflows CLI, and the deploy (through Helm Charts) of fission
# and fission-workflows framework into the minikube.
#
# Author: Diego Martin (October 2018)
#
################################################################################


# Versioning
#
# For the ease of seamless reuse of this here we have all the versions numbers
#
################################################################################

MINIKUBE_VER_M="0.29"
MINIKUBE_VER_m="0"
FISSION_VER="0.11.0"
FISSION_WORKFLOWS_VER="0.5.0"

echo "Starting install..."
echo "Dependeing on the connection and your device this might take a few minutes..."


# Pre-requisites:
#
# For minikube to work we need "something" to handle the virtualization layer
# there's a few options there, but the one with the most easy and stright
# forward install is VirtualBox.
#
################################################################################

echo "Updating sources..."
sudo apt update

echo "Installing pre-requisites..."
sudo apt install -y apt-transport-https virtualbox virtualbox-ext-pack


# Kubernetes
#
# When installing kubectl, minikube, and helm there are a few different ways to
# do it here we are using the most close to the "native package manager" way.
# If you don't like it you could just comment this part and install them as you
# wish.
#
################################################################################

echo "Adding sources and downloading .deb packages..."

# kubectl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo touch /etc/apt/sources.list.d/kubernetes.list
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list

# minikube
curl -Lo minikube.deb https://github.com/kubernetes/minikube/releases/download/v${MINIKUBE_VER_M}.${MINIKUBE_VER_m}/minikube_${MINIKUBE_VER_M}-${MINIKUBE_VER_m}.deb

# Helm
curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > get_helm.sh
chmod 700 get_helm.sh

echo "Updating sources..."
sudo apt update

echo "Installing kubectl..."
sudo apt install -y kubectl

echo "Installing minikube..."
sudo dpkg -i minikube.deb

echo "Installing helm..."
sudo get_helm.sh


# Fission CLIs
#
# Fission provides two CLI tools for the ease of handling the Fission FaaS and
# Fission Workflows respectively. We will proceed to install them.
#
################################################################################

echo "Downloading Fission and Fission Workflows CLI binaries..."

# Fission CLI
curl -Lo fission https://github.com/fission/fission/releases/download/${FISSION_VER}/fission-cli-linux

# Fission-workflows CLI
curl -o fission-workflows https://github.com/fission/fission-workflows/releases/download/${FISSION_WORKFLOWS_VER}/wfcli-linux

echo "Installing Fission and Fission Workflows CLI..."
chmod +x fission{,-workflows}
sudo mv fission{,-workflows} /usr/local/bin/


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


# Clean up
#
# During the install we have accumulated a few thing that we no longer need, so
# we will clean up the current directory before going any further.
#
################################################################################

echo "Cleaning temp files..."

# Minikube
rm -rf minikube.deb

# Helm
rm -rf get_helm.sh

echo "System ready!"
