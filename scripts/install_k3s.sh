#!/bin/bash -eu

export DEBIAN_FRONTEND=noninteractive

# Install prerequisite tools for k3s
apt-get update
apt-get upgrade -qq -y
apt-get install -y curl

# Install k3s
# Tell k3s installation script to re-enable deprecated APIs as some GK helm charts still depend on those
export INSTALL_K3S_EXEC="--no-deploy=traefik --kube-apiserver-arg runtime-config=apps/v1beta1=true,apps/v1beta2=true,extensions/v1beta1/daemonsets=true,extensions/v1beta1/deployments=true,extensions/v1beta1/replicasets=true,extensions/v1beta1/networkpolicies=true,extensions/v1beta1/podsecuritypolicies=true"
export INSTALL_K3S_VERSION="v1.17.3+k3s1"

# Execute k3s installation script, obtained from https://get.k3s.io (https://raw.githubusercontent.com/rancher/k3s/master/install.sh)
bash /tmp/install_k3s.sh &
wait $!
sleep 120 # Give k3s installer some extra time to finish

mkdir -p /home/vagrant/.kube/
mkdir -p /root/.kube/
cp /etc/rancher/k3s/k3s.yaml /home/vagrant/.kube/config
cp /etc/rancher/k3s/k3s.yaml /root/.kube/config

chown vagrant:vagrant -R /home/vagrant/.kube/