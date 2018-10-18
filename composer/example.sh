#!/bin/bash
#
# The following script handles the deploy of the example app into the IBM
# Bluemix platform.
#
# Be aware that the script assumes that you have already configured the IBM
# Cloud CLI by yourself with your credentials. If that's not the case remember
# to issue the following line before executing this script:
#
#   $> bx login
#
# NOTE: Remember that the free tier of Bluemix right now only let you play with
# the eu-gb region! And also that you need to set properly the Cloud Foundry
# organization (usually your username by default) and create a space beforehand
# at: https://console.bluemix.net/openwhisk/learn/cli
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
# Before start and in case this is not the first time running the example we
# will make a clean-up of the functions in the Bluemix and also we will reset
# the functions (in case this is done after using the Fission example) and
# then recover the bin that we have alreasy got...
#
################################################################################

echo "$alert > Let's start with the preparations for the example...$reset"

# Let's clean first
echo "$alert > Let's start with the cleanup...$reset"
for i in "${srcFiles[@]}"
do
	fsh wsk action delete FWTt/$i
done
fsh app delete FWTt/simpleTodos

# Now we call the restore function..
resetWithBin

# Enviroment
#
# Now we will deploy the functions and inspect the workflow through the fsh
# shell preview utility.
#
################################################################################

# Let's deploy the functions
echo "$alert > Let's deploy the functions...$reset"
for i in "${srcFiles[@]}"
do
	fsh wsk action create FWTt/$i $gitdir/src/$i.js
done

echo "$alert > Now we create the composition/workflow...$reset"
# Now we create the composition
fsh app create FWTt/simpleTodos $gitdir/src/composer_todosAppComposition.js

echo "$alert > And after that we expose it...$reset"
# Now we expose it
fsh webbify FWTt/simpleTodos

echo "$alert > Let's check how that composition looks like...$reset"
# Let's see how the composition looks like..
fsh app preview $gitdir/src/composer_todosAppComposition.js

# A break-point..
read -s

# Now we are going to reset to a known state the bin and then check that
# everything has been setted up properly :)
echo "$alert > Let's reset the bin to a known-state...$reset"
fsh wsk action invoke FWTt/updateTodos
echo "$alert > And now let's check the composition is working...$reset"
curl "https://openwhisk.eu-gb.bluemix.net/api/v1/web/${USER}_${SPACE}/FWTt/simpleTodos.json"

# A break-point..
read -s


# Front-end
################################################################################

echo "$alert > Since everything is in place, let's start the front-end...$reset"
# Now let's the fun begin! :D
cliTodosApp composer
