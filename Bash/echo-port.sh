#!/usr/bin/env bash
# /dev/tcp/*
# is not a file location (?) but a built-in specific to bash
# the no new line is just to avoid echoing only a newline char to host.
# /dev/tcp/${target_ip}/${target_port}
#
# echo -n > /dev/tcp/20.20.20.220/22 && echo TCP connect || echo Not open

function echohost() {
    if [[ -n "${1}" ]]; then
        local target_host="${1}"
    else
        echo 'Args expected: $script $target_ipv4 $target_port'
        return
    fi
    if [[ -n "${2}" ]]; then
        local target_port="${2}"
    else
        echo 'Args expected: $script $target_ipv4 $target_port'
        return
    fi

    echo -n > "/dev/tcp/${1}/${2}" && echo "Connect success at ${1}:${2}" || echo "Unable to connect; target IP ${1}:${2}"
}
