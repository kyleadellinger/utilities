#!/usr/bin/env bash

## scan /bus/scsi
for dev in /sys/bus/scsi/devices/[0-9]\:*/rescan
    do echo 1> ${dev}
    done

## scan scsi host
for dev in /sys/class/scsi_host/host[0-9]/scan
do echo "- - -" > ${dev}
done

