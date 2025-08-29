#!/usr/bin/env bash

set -e

VERSION=1.25.0
GOURL="https://go.dev/dl/go${VERSION}.linux-amd64.tar.gz"

curl -LJO "$GOURL"
rm -rf /usr/local/go && tar -C /usr/local -xzf go${VERSION}.linux-amd64.tar.gz

echo "Install go v $VERSION complete"
echo "Reminder set PATH, if not set: 'export PATH=$PATH:/usr/local/go/bin'"
