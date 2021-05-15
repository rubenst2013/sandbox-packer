#!/bin/bash -eux

export DEBIAN_FRONTEND=noninteractive

# Install Ansible repository.
apt -y update && apt-get -y upgrade
apt -y install python3 python3-pip software-properties-common
pip3 install ansible

# Install Ansible.
apt -y update
apt -y install ansible
