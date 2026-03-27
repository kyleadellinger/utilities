#!/usr/bin/env bash

unset TARGETPATH
BVERBOSE=0

function testpath() {
    for a in "${@}"; do
        if [[ -d "${a}" ]]; then
            echo "${a} exists: directory"
        elif [[ -f "${a}" ]]; then
            echo "${a} exists: file"
        elif [[ -e "${a}" ]]; then
            echo "${a} exists: unknown type"
        else
            echo "${a} doesn't exist"
        fi
    done
}

function kinfo() {
    if [ "$BVERBOSE" = "1" ]; then
        echo "$@"
    fi
}

# provide getopts two things: 1. list of options, 2. name of var into which it will put the option it finds while parsing.
# note:
# in ':vp:'
# the leading colon tells getopts not to report error messages
# the colon after the 'p' indicates that the 'p' option has an argument with it
while getopts ':vp:' ARG ; do
    echo "checking ${ARG}"
    case "$ARG" in
        v ) BVERBOSE=1 ;;
        p ) TARGETPATH="$OPTARG" ;;
        : ) echo "error: no arg supplied to $TARGETPATH option" ;;
        * )
            echo "error: unknown option ${OPTARG}"
            echo "  valid options: p v"
        ;;
    esac
done

shift $((OPTIND -1))
# getops builtin keeps track of its location--
# OPTIND is index of next arg to be considered;
# once args have been parsed, remove all option-related args from consideration.

if [ -z "$TARGETPATH" ]; then # no, this is not yet it
    cat <<EOF
Usage:
    argger.sh \$file
    argger.sh -p \$file
    argger.sh -v -p \$file
EOF
    exit 0
fi

testpath "$TARGETPATH"
