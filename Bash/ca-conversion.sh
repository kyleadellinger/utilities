#!/bin/bash

# notes on converting .cert to .crt
# debian only supports X509 form, aka .crt

read -p "full file path and name of cert to convert: " CERT_PATH
read -p "name of converted cert: " NEW_NAME

openssl x509 -inform PEM -in "$CERT_PATH" -out "${NEW_NAME}.crt"
