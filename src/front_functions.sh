#!/bin/bash
#
# The following script contains the common functions used in the examples for
# creating the front-end for the examples.
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
readonly  todo=$(tput bold; tput setaf 12)
readonly   wip=$(tput bold; tput setaf 11)
readonly  done=$(tput bold; tput setaf 8)
readonly alert=$(tput bold; tput setaf 10)
