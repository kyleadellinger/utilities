#!/usr/bin/env bash
#
# valid fingerprint:
# pub   rsa3072 2023-08-23 [SC] [expires: 2025-08-22]
#      4EFC 5906 96CB 15B8 7C73  A3AD 82CC 8797 C838 DCFD
# uid                      Zabbly Kernel Builds <info@zabbly.com>
# sub   rsa3072 2023-08-23 [E] [expires: 2025-08-22]
#
# validate: curl -fsSL https://pkgs.zabbly.com/key.asc | gpg --show-keys --fingerprint
#
mkdir -p /etc/apt/keyrings/
curl -fsSL https://pkgs.zabbly.com/key.asc -o /etc/apt/keyrings/zabbly.asc


