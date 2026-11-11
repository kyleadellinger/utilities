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

########
# helper functions to run ssh-agent
# and ensure not just continually starting ssh-agent processes
######## 

SSH_ENV="${HOME}/.ssh/agent.pid"
USER_KEY_FILE="${HOME}/.ssh/id_ed25519"

function _ssh-agent-wrapper()
{
    ssh-agent -s | sed 's/^echo/#echo/' > "${SSH_ENV}"
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
}

function run-ssh-agent()
{
    if [ -f "${SSH_ENV}" ]; then
        . "${SSH_ENV}" > /dev/null
        kill -1 "${SSH_AGENT_PID}" 2>/dev/null || _ssh-agent-wrapper
    else
        _ssh-agent-wrapper
    fi
    ssh-add -l &> /dev/null || ssh-add "${USER_KEY_FILE}" 
}

