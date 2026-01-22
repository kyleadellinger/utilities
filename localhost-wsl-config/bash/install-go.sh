#!/usr/bin/env bash
#
# https://go.dev/dl/go1.22.5.linux-amd64.tar.gz
set -e
set -x
wget https://go.dev/dl/go1.22.5.linux-amd64.tar.gz

# sudo command needed for this
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.22.5.linux-amd64.tar.gz

# but not wanted for this 
echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.bashrc

