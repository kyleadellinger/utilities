#!/usr/bin/env bash

# 1. leading colon in optstring suppresses error msg from getopts
# 2. trailing colon after available option in optstring indicates a following argument. the arg for each option is stored in $OPTARG, which is a built-in variable that works with getopts.
while getopts :a:b: options; do
    case $options in
        a) var1=$OPTARG;;
        b) var2=$OPTARG;;
        /?) echo "unknown option: $OPTARG";;
        :) echo "Both options require an argument";;
    esac
done

# then test for variables that exist and print them.
[[ -z $var1 ]] || echo "Option A is $var1"
[[ -z $var2 ]] || echo "Option B is $var2"

