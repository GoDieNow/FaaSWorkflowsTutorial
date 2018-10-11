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


# Colouring
#
# A few variables to compact the colouring of the echos..
#
################################################################################

readonly reset=$(tput sgr0)
readonly alert=$(tput bold; tput setaf 10)


echo "$alert > Starting install...$reset"
echo "$alert > Dependeing on the connection and your device this might take a couple of minutes...$reset"


# Pre-requisites:
#
# For the FSH Shell to work we will need to have NodeJS/NPM installed and in a
# just-installed Ubuntu18 will also need: libgconf-2.so.4
#
################################################################################

echo "$alert > Updating sources...$reset"
curl -sL https://deb.nodesource.com/setup_8.x -o nodesource_setup.sh
sudo bash nodesource_setup.sh

echo "$alert > Installing pre-requisites...$reset"
sudo apt install -y jq libgconf-2-4 nodejs


# IBM Cloud CLI and pluggins:
#
# The IBM Cloud CLI gives you access to the whole IBM Cloud ecosystem through
# the in-built pluggin system. Here we will be installing and useing the one
# related to Cloud-Functions
#
################################################################################

echo "$alert > Installing the IBM Cloud CLI...$reset"
curl -fsSL https://clis.ng.bluemix.net/install/linux | sh

echo "$alert > Installing the Cloud-Functions pluggin...$reset"
bx plugin install Cloud-Functions -r bluemix

# FSH Shell:
#
# The FSH Shell is distributed as a npm package that should be installed global
# in the system and provides a neat interface for the creation and
# visualization of Function compositions.
#
################################################################################

echo "$alert > Installing the fsh shell...$reset"
sudo npm install -g @ibm-functions/shell --unsafe-perm=true


# Clean up
#
# During the install we have accumulated a few thing that we no longer need, so
# we will clean up the current directory before going any further.
#
################################################################################

echo "$alert > Cleaning temp files...$reset"

# NodeJS
rm -rf nodesource_setup.sh

echo "$alert > System ready!$reset"
