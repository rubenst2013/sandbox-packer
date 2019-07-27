#!/bin/bash -e

export DEBIAN_FRONTEND=noninteractive

add-apt-repository -y ppa:teejee2008/ppa

# Update the existing system to the latest patch version before trying to install a newer kernel.
apt-get update
apt-get upgrade -qq -y

apt-get install -y ukuu gcc make perl

ukuu --check

ukuu --install v5.2.3