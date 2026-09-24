#!/usr/bin/env bash

echo "Bash source: ${BASH_SOURCE}"

echo "Script at: ${@}"
for i in "${@}" ; do echo "${i}" ; done

echo "Args count: ${#}"
for i in "${#}" ; do echo "${i}" ; done

if [[ -n "${1}" ]]; then
    echo "${1}"
else
    echo 'no args :-('
fi

