#!/bin/bash

# to switch the path of the secret in the env shell scripts

# sed 's/\/home\/kyle\/bash/\/home\/ubuntu\/basher/' appeusrc.sh

for file in $(ls)
do
    sed -i 's/\/home\/ubuntu\/basher/\/home\/kyle\/bash/' "$file"
done
