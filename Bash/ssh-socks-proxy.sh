#!/usr/bin/env bash
set -e

# Could obviously be less hacky, but these are my reminders
BOX=$(hostname --fqdn)

if [ -z "$1" ] ; then
    read -p "Select port: " USING_PORT
else
    USING_PORT=$1
fi

if [ -d "$HOME/.ssh" ]
then
    CONTROL_PATH="$HOME/.ssh"
else
    CONTROL_PATH="$HOME"
fi

ssh -o "ControlMaster=auto" \
    -o "ControlPersist=no" \
    -o "ControlPath=$CONTROL_PATH" \
    -CfN \
    # compress, background, don't execute a command
    -D "$USING_PORT" \
    "${USER}@${BOX}"
