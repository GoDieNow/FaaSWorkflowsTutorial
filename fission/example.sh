#!/bin/bash
#
# The following script handles the deploy of the example app within the Fission
# Workflows already deployed.
#
# Be aware that the script assumes that you have a proper Fission Workflows
# already in place before executing it.
#
# Author: Diego Martin (October 2018)
#
################################################################################


# Common bash functions
#
# Since the front for the example is the same in this and in the other example
# a few things are in a different file that we will source
#
################################################################################

source ../src/front_functions.sh


# Preparations
#
# Due to have the source code of the functions have been implemented we need to
# do a couple of things in order to get the real functions we're going to use.
#
################################################################################

echo "$alert > Let's start with the preparations for the example...$reset"
# First we get a new bin.
getBin

# A break-point..
read -s

echo "$alert > Now we turn the generic functions into the ones Fission expects...$reset"
# Then we transform the simple JS functions into the ones Fission will be
# expecting to get.
for i in "${srcFiles[@]}"
do
	cat $gitdir/src/fission_exporter.js >> $gitdir/src/$i.js
done


# Enviroment
#
# We will set the enviroment and deploy the functions in the "old fashion way"™
# (AKA as if we've done it manually) mainly because when using the specs or the
# source-pkg ways they sometimes "just won't work"™
#
################################################################################

echo "$alert > Now let's set up the enviroment...$reset"
# First we create the NodeJS enviroment
fission env create --name nodejs --image fission/node-env --externalnetwork

# A break-point..
read -s

echo "$alert > Let's add the functions...$reset"
# Now we deploy our functions into into that enviroment
for i in "${srcFiles[@]}"
do
	fission fn create --name $i --code $gitdir/src/$i.js --env nodejs
done

echo "$alert > And let's test them to check everything went well...$reset"
# Let's just check everything is right there...
for i in "${srcFiles[@]}"
do
	fission fn test --name $i
done

# A break-point..
read -s

echo "$alert > Now let's deploy the workflow and test that everything went well...$reset"
# Now let's deploy the workflow and test it went well
fission fn create --name simpleTodos --env workflow --src $gitdir/src/fission_todosApp.wf.yaml

fission fn test --name simpleTodos

# A break-point..
read -s


# Front-end
################################################################################

echo "$alert > Since everything is in place, let's start the front-end...$reset"
# Now let's the fun begin! :D
cliTodosApp fission
