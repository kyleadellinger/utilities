#!/bin/bash
#
# git clone of repo sagitta to build vyos iso image

git clone -b sagitta --single-branch https://github.com/vyos/vyos-build \
    && cp container-script.sh ./vyos-build \
    && cd vyos-build \
    && docker run --rm -it --privileged -v $(pwd):/vyos -w /vyos vyos/vyos-build:sagitta bash
