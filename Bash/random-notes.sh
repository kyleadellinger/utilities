#!/usr/bin/env bash

######################################
# a bash package that could be used in terminal as well as command line function:

function my_script() {
    set -o errexit
    set -o errtrace
    set -o nounset
    set -o pipefail
}

if [[ "${BASH_SOURCE[0]:-}" != "${0}" ]]; then
    export -f my_script
else
    my_script "$@"
    exit
fi

# note: allows user to 'source' script or invoke as script.
######################################


