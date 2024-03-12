#!/bin/bash
#
# script to be run inside vyos container to build vyos image sagitta
#
sudo make clean && sudo ./build-vyos-image iso \
    --architecture amd64 \
    --build-by "" \
    --build-comment ""
