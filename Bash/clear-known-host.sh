#!/usr/bin/env bash

if [[ -n "$1" ]]; then
    host_to_remove=$1
else
    read -p 'Enter host to remove from ~/.ssh/known_hosts file: ' host_to_remove
fi

ssh-keygen -f ~/.ssh/known_hosts -R "$host_to_remove"
