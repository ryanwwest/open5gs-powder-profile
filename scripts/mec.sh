#!/bin/bash

# This script installs UERANSIM and its prerequisites on the ran node as root user then runs it. Configs still need to be adjusted.

# Any subsequent(*) commands which fail will cause the shell script to exit immediately
set -e

# load config values
source /local/repository/scripts/setup-config

# automate grub prompt during installation
echo "SET grub-pc/install_devices /dev/sda" | sudo debconf-communicate

touch setup-complete
