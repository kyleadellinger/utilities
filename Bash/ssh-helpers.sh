#!/usr/bin/env bash

# notes:
# local port forwarding
# - local port forwarding: connect from your client to your server, opening a tunnel for another program on your client to connect to.
#    ssh -L 8888:localhost:8888 name.host.com
#    - first 8888 is port on client so that other program (such as browser) can connect to.
#    - localhost is seen from end of tunnel, aka on the destination server (name.host.com).
#    - second 8888 is port you want to connect to on server site.
#    - name.host.com is name of ssh server where you connect, which is also endpoint of ssh tunnel.
#
# remote port forwarding
# - remote port forwarding: connect from your client to your server to open a tunnel so that a program on your server can connect via a port on the server to a host:port on your client.
#     ssh -R [remote_addr:]remote_port:local_addr:local_port [user@gateway_addr]
#    - by default, ssh tunnel allows using only gateway's localhost as the remote address.
#      - local port will become accessible only from inside of the gateway server itself.
#    - remote port forwarding will expose dev service from your laptop to the public internet.


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

#SSH_AUTH_SOCK=/tmp/ssh-krhNmbwqVgO8/agent.1880
#SSH_AGENT_PID=1882

SSH_ENV="${HOME}/.ssh/agent.pid"
USER_KEY_FILE="${HOME}/.ssh/id_ed25519"

# these don't quite work as expected
# mostly here for later reference/study/review

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
        kill -9 "${SSH_AGENT_PID}" 2>/dev/null || _ssh-agent-wrapper
    else
        _ssh-agent-wrapper
    fi
    ssh-add -l &> /dev/null || ssh-add "${USER_KEY_FILE}" 
}

# similar to above, though this does work and is useful,
# though primarily for ref/review/study
function ssh-agent-find-sockets()
{
    find /tmp -uid $(id -u) -type s -name agent.\* 2>/dev/null
}

function kill-all-ssh-agent-instances()
{
    for p in $(pgrep ssh-agent)
    do
        kill -9 "$p"
    done
}

