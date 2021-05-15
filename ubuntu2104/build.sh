#!/usr/bin/bash -eu

export PACKER_CACHE_DIR='/usr/local/share/packer/cache/'

version="0.1.0"
build_number="b01"
branch_name="master"

packer build --var "version=${version}" --var "build_number=${build_number}" --var "branch_name=${branch_name}" box-config.json.pkr.hcl

vagrant box add --name "rst/ubuntu-server-21.04-${version}-${build_number}" "builds/virtualbox-ubuntu-2104-${version}-${build_number}-${branch_name}.box"