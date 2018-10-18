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

readonly   wip=$(tput bold; tput setaf 11)
readonly  todo=$(tput bold; tput setaf 12)
readonly  done=$(tput bold; tput setaf 8)
readonly alert=$(tput bold; tput setaf 10)
readonly error=$(tput bold; tput setaf 9)
readonly reset=$(tput sgr0)


# Vars
#
# All the vars we may need are here.
#
################################################################################

readonly USER=""
readonly SPACE=""
readonly TDFile="todos.tmp"
readonly gitdir=$(git rev-parse --show-toplevel)
readonly srcFiles=( "addTodo" "delTodo" "doneTodo" "getTodos" "showTodos" "updateTodos" "wipTodo" )


# Functions
#
# All the common functions to create the front-end for the ToDo App.
#
################################################################################

# Get a new bin from server, set it in the functions needed, and stash the
# changes for future use.
function getBin() {

    echo "$alert > Let's ask for a new bin and update our SC with it...$reset"
    sed "s/REPLACE_ME/$(curl -H "Content-Type: application/json" -X POST -d '{"todo":{"2":"Finish the ToDo App!"},"wip":{"1":"Attend the FaaS Workflows Tutorial!"},"done":{"0":"Create the initial test-ToDo :)"},"count":"3"}' https://api.jsonbin.io/b | jq '.id' | tr -d '"')/" $gitdir/src/getTodos.js $gitdir/src/updateTodos.js

    echo "$alert > And also let's keep a copy of the changes for later...$reset"
    git stash
    git stash apply

}

# Resets the files in /src and then apply the stashed estate to keep the bin
# already gotten in the right place
function resetWithBin() {

    echo "$alert > Let's reset the functions SC...$reset"
    git checkout $gitdir/src/

    echo "$alert > And now we apply the changes we saved before...$reset"
    git stash apply

}

# Wrapper for curl-ing the Composer function
function call_composer() {

    tmp="$(echo "${@:3}")"

    curl -s -H 'Content-Type: application/json' -X POST -d "{\"$1\":{\"$2\":\"$tmp\"}}" "https://openwhisk.eu-gb.bluemix.net/api/v1/web/${USER}_${SPACE}/FWTt/simpleTodos.json" > $TDFile

}

# Wrapper for curl-ing the Fission function
function call_fission() {

    tmp="$(echo "${@:3}")"

    curl -s -H 'Content-Type: application/json' -X POST -d "{\"$1\":{\"$2\":\"$tmp\"}}" "http://$FISSION_ROUTER/simpleTodos" > $TDFile

}

# Wrapper to abstract the calling to composer/fission seamlessly
function call() {

	call_$1 ${@:2}

}

# Help-function to get different parts of the JSON we save in $TDFile when
# using call*
function get() {

    cat $TDFile | jq -cM ".$1" | sed "s/,/\n/g" | sed -r "s/(\{*\")([0-9]*)(\":)(.*)/\2\ \-\>\ \4/g" | tr -d '}' | tr -d '{' | sed "s/^null//"

}

# The actual Simple CLI Front-end for the ToDos App..
function cliTodosApp() {

    # Temp vars..
    errors=""
    todos=""
    wips=""
    dones=""

    env="$1"

    # First call...
    call $env

    while :
    do

        clear
        errors="$(get "error")"
        todos="$(get "data.todo")"
        wips="$(get "data.wip")"
        dones="$(get "data.done")"

        # TODO check errors
        if ! [[ -z "${errors}" ]]; then
            echo -e "$error > Something failed! Error received:\n $errors $reset"
        fi

        # Show the data
        echo -e "${alert}Welcome to the Simple ToDos App!\n-> Here you have your ToDos$reset"
        echo -e "\n$todo ToDos:\n\n$todos $reset\n"
        echo -e "$wip WiPs:\n\n$wips $reset\n"
        echo -e "$done Done:\n\n$dones $reset\n"

        # Wait for orders
        echo "$alert > Please state your command: $reset"
        read -a order

        # If order is quit, exit or q then we exit...
        case ${order[0]} in
            "quit"|"exit"|"q")
                echo "$alert > Don't forget to do your ToDos! Bye-bye! :) $reset"
                exit 0
                ;;
            *)
        esac

        # Exec orders
        call $env "action" "${order[0]}" "${order[@]:1}"

        # And go back again! :D
    done

}
