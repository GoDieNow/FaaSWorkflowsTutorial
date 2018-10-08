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

echo "Starting install..."
echo "Dependeing on the connection and your device this might take a couple of minutes..."


# Pre-requisites:
#
# For the FSH Shell to work we will need to have NodeJS/NPM installed and in a
# just-installed Ubuntu18 will also need: libgconf-2.so.4
#
################################################################################

echo "Updating sources..."
curl -sL https://deb.nodesource.com/setup_8.x -o nodesource_setup.sh
sudo bash nodesource_setup.sh

echo "Installing pre-requisites..."
sudo apt install -y nodejs libgconf-2-4


# IBM Cloud CLI and pluggins:
#
# The IBM Cloud CLI gives you access to the whole IBM Cloud ecosystem through
# the in-built pluggin system. Here we will be installing and useing the one
# related to Cloud-Functions
#
################################################################################

echo "Installing the IBM Cloud CLI..."
curl -fsSL https://clis.ng.bluemix.net/install/linux | sh

echo "Installing the Cloud-Functions pluggin..."
bx plugin install Cloud-Functions -r bluemix

# FSH Shell:
#
# The FSH Shell is distributed as a npm package that should be installed global
# in the system and provides a neat interface for the creation and
# visualization of Function compositions.
#
################################################################################

echo "Installing the fsh shell..."
sudo npm install -g @ibm-functions/shell --unsafe-perm=true


# Clean up
#
# During the install we have accumulated a few thing that we no longer need, so
# we will clean up the current directory before going any further.
#
################################################################################

echo "Cleaning temp files..."

# NodeJS
rm -rf nodesource_setup.sh

echo "System ready!"
