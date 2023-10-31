#!/bin/bash
cp -r /home/ubuntu/pass/basher ~ && sudo chmod +x ~/basher/scan_functions.sh
cp /home/ubuntu/pass/wss-unified-agent.config ~
echo "alias Scan='/home/ubuntu/basher/scan_functions.sh'" >> ~/.bashrc
