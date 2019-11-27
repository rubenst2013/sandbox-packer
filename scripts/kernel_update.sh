#!/bin/bash -eux

export DEBIAN_FRONTEND=noninteractive

kernel_version="v5.3.13"

add-apt-repository -y ppa:teejee2008/ppa

# Update the existing system to the latest patch version before trying to install a newer kernel.
apt-get update
apt-get upgrade -qq -y

apt-get install -y ukuu gcc make perl
mkdir -p "/home/vagrant/.cache/ukuu/${kernel_version}/amd64"

ukuu --check

ukuu --install "${kernel_version}"