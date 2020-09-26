#!/usr/bin/bash -eu

export PACKER_CACHE_DIR='/usr/local/share/packer/cache/' 

packer build --var "version=0.3.0" --var "build_number=b05" --var "branch_name=master" box-config.json