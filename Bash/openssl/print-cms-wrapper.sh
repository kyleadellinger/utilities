#!/usr/bin/env bash

path_to=""

openssl cms -in "${path_to}" -cmsout -inform DER -print
