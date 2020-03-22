#!/bin/bash -eux

export DEBIAN_FRONTEND=noninteractive

# Uninstall Ansible and dependencies.
pip uninstall ansible
apt-get remove python-pip python-dev

# Apt cleanup.
apt autoremove
apt update

# Delete unneeded files.
rm -f /home/vagrant/*.sh

# Use fstrim to shrink the disks data files.
fstrim --all --verbose || true

# Add `sync` so Packer doesn't quit too early, before the large file is deleted.
sync