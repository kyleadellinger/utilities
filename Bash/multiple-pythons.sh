#!/bin/bash

# REFERENCE

sudo apt install software-properties-common -y
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt install python3.9 -y

# sudo update-alternatives --install /usr/bin/python python /usr/bin/python3.9 1
# sudo update-alternatives --install /usr/bin/python python /usr/bin/python3.10 2
# etc 

# then:
# sudo update-alternatives --config python
# OR
# sudo update-alternatives --set python /usr/bin/python3.9
