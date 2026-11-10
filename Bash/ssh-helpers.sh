#!/usr/bin/env bash

function ssh-remove-known-host() {
    if [[ -n "$1" ]]; then
    local host_to_remove=$1
    else
        read -p 'Enter host to remove from ~/.ssh/known_hosts file: ' host_to_remove
    fi
    ssh-keygen -f ~/.ssh/known_hosts -R "$host_to_remove"
}

function get-ssh-fingerprint() {
    if [[ -z "$1" ]]; then
        echo 'Provide path to ssh key.'
        exit 1
    fi
    ssh-keygen -lf "${1}"
}

