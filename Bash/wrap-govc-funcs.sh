#!/usr/bin/env bash
set -e

isit=$(which govc || echo 'no')

set +e

function dc3_vm_info() {
    if [ -n "$1" ]; then
        echo 'VM FQDN expected'
        exit 2
    fi

    govc vm.info -dc='DC3 Manassas, VA' "$1"
}

echo "$1"

dc3_vm_info "$1"
# what am i doing that this doesn't work as i expect?    
