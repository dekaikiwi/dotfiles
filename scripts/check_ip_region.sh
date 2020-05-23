#!/bin/bash

# Script that will store the current region of your global IP address
#  to a file known as ip_region.txt in your home directory.
# Useful for making sure you are connected to VPN

curl ipinfo.io | jq '.region' > $HOME/ip_region.txt
