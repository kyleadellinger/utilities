#!/usr/bin/env bash

path_to_cert_to_test=""

openssl x509 -in "${path_to_cert_to_test}" -noout -fingerprint
