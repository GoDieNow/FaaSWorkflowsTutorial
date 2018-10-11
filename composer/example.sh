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


#
