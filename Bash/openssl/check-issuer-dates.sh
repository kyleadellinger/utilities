#!/usr/bin/env bash

path_to_pem_cert=""

openssl x509 -in "${path_to_pem_cert}" -noout -subject -issuer -dates

