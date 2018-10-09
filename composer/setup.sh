#!/bin/bash
#
# The following script gets your system ready to use the IBM Cloud CLI, and
# the related pluggins for FaaS and FaaS Composition.
#
# The setup includes the install of: NodeJS, IBM Cloud CLI, IBM Cloud-Functions
# pluggins, and FSH shell.
#
# Author: Diego Martin (October 2018)
#
################################################################################

echo "$(tput setaf 1)Starting install...$(tput sgr 0)"
echo "$(tput setaf 1)Dependeing on the connection and your device this might take a couple of minutes...$(tput sgr 0)"


# Pre-requisites:
#
# For the FSH Shell to work we will need to have NodeJS/NPM installed and in a
# just-installed Ubuntu18 will also need: libgconf-2.so.4
#
################################################################################

echo "$(tput setaf 1)Updating sources...$(tput sgr 0)"
curl -sL https://deb.nodesource.com/setup_8.x -o nodesource_setup.sh
sudo bash nodesource_setup.sh

echo "$(tput setaf 1)Installing pre-requisites...$(tput sgr 0)"
sudo apt install -y nodejs libgconf-2-4


# IBM Cloud CLI and pluggins:
#
# The IBM Cloud CLI gives you access to the whole IBM Cloud ecosystem through
# the in-built pluggin system. Here we will be installing and useing the one
# related to Cloud-Functions
#
################################################################################

echo "$(tput setaf 1)Installing the IBM Cloud CLI...$(tput sgr 0)"
curl -fsSL https://clis.ng.bluemix.net/install/linux | sh

echo "$(tput setaf 1)Installing the Cloud-Functions pluggin...$(tput sgr 0)"
bx plugin install Cloud-Functions -r bluemix

# FSH Shell:
#
# The FSH Shell is distributed as a npm package that should be installed global
# in the system and provides a neat interface for the creation and
# visualization of Function compositions.
#
################################################################################

echo "$(tput setaf 1)Installing the fsh shell...$(tput sgr 0)"
sudo npm install -g @ibm-functions/shell --unsafe-perm=true


# Clean up
#
# During the install we have accumulated a few thing that we no longer need, so
# we will clean up the current directory before going any further.
#
################################################################################

echo "$(tput setaf 1)Cleaning temp files...$(tput sgr 0)"

# NodeJS
rm -rf nodesource_setup.sh

echo "$(tput setaf 1)System ready!$(tput sgr 0)"
