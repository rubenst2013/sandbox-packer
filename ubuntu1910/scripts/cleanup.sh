#!/bin/bash -eux

export DEBIAN_FRONTEND=noninteractive

# Uninstall Ansible and remove PPA.
apt -y remove --purge ansible
apt-add-repository --remove ppa:ansible/ansible

# Apt cleanup.
apt autoremove
apt update

# Delete unneeded files.
rm -f /home/vagrant/*.sh

# Use fstrim to shrink the disks data files.
fstrim --all --verbose || true

# Add `sync` so Packer doesn't quit too early, before the large file is deleted.
sync