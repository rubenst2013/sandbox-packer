#!/usr/bin/bash -eu

export PACKER_CACHE_DIR='/usr/local/share/packer/cache/' 

version="0.5.0"
build_number="b01"
branch_name="master"

packer build --var "version=${version}" --var "build_number=${build_number}" --var "branch_name=${branch_name}" box-config.json

vagrant box add --name "rst/ubuntu-server-20.04-${version}-${build_number}" "builds/virtualbox-ubuntu-2004-${version}-${build_number}-${branch_name}.box"