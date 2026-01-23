#!/usr/bin/env bash

# example pull Rocky 9 incus image
# name it, create user, install some utilities, push file
set -e

LOCAL_DIR_OF_FILES_TO_PUSH=""
PUSH_FILE1="{LOCAL_DIR_OF_FILES_TO_PUSH}/file.file"
PUSH_FILE2=""
DEST_DIR=""
DEST_FILENAME="${DEST_DIR}/file.name"

if [ -z "$1" ]
then
    read -p "Input name of Rocky 9 instance: " instancename
else
    instancename=$!
fi

if [ -z $2 ]
then
    read -p "Input user to add: " newuser
else
    newuser=$2
fi

incus launch images:rockylinux/9 "$instancename"

incus exec "$instancename" -- adduser "$newuser"
incus exec "$instancename" -- passwd "$newuser" # prompt to set newuser password during creation
incus exec "$instancename" -- dnf install -y sudo vim ncruses less file wget lsof # some utils
incus exec "$instancename" -- usermod -aG wheel "$newuser" # add user to wheel
incus file push "${PUSH_FILE1}" "${instancename}/home/${newuser}/${DEST_FILENAME}"
incus file push "${PUSH_FILE2}" "${instancename}/etc/location/filename"
