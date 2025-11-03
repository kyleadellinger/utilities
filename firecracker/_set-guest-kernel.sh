#!/usr/bin/env bash

FIRECRACKER_SOCK=/tmp/firecracker.socket
THIS_DIR=/home/bobx/firecracker/notes
GUEST_KERNEL="${THIS_DIR}/vmlinux.bin"
ROOTFS="${THIS_DIR}/bionic.rootfs.ext4"

# set guest kernel
curl --unix-socket "$FIRECRACKER_SOCK" -i \
	-X PUT 'http://localhost/boot-source' \
	-H 'Accept: application/json' \
	-H 'Content-Type: application/json' \
	-d "{
		\"kernel_image_path\": \"${GUEST_KERNEL}\",
		\"boot_args\": \"console=ttyS0 reboot=k panic=1 pci=off\"
	}"

# set guest rootfs
curl --unix-socket "$FIRECRACKER_SOCK" -i \
	-X PUT 'http://localhost/drives/rootfs' \
	-H 'Accept: application/json' \
	-H 'Content-Type: application/json' \
	-d "{
		\"drive_id\": \"rootfs\",
		\"path_on_host\": \"${ROOTFS}\",
		\"is_root_device\": true,
		\"is_read_only\": false
	}"

# start guest machine
curl --unix-socket "$FIRECRACKER_SOCK" -i \
	-X PUT 'http://localhost/actions' \
	-H 'Accept: application/json' \
	-H 'Content-Type: application/json' \
	-d '{
		"action_type": "InstanceStart"
	}'

