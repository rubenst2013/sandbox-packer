#!/bin/bash -eu

export DEBIAN_FRONTEND=noninteractive

kernel_version="5.5.1"

# Move kernel update helper to its proper location
mv /tmp/ubuntu-mainline-kernel.sh /usr/local/bin/
chmod +x /usr/local/bin/ubuntu-mainline-kernel.sh


# Update the existing system to the latest patch version before trying to install a newer kernel.
apt-get update
apt-get upgrade -qq -y
apt-get install -y gcc make perl

ubuntu-mainline-kernel.sh -c                        # Check for available (newer) kernel versions
ubuntu-mainline-kernel.sh -i "${kernel_version}"    # Install specified mainline kernel