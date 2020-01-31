#!/bin/bash -eu

export DEBIAN_FRONTEND=noninteractive

# Install k3s
# https://k3s.io
# Zero-ops single node Kubernetes cluster for workstations and appliances
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--no-deploy=traefik --kube-apiserver-arg runtime-config=apps/v1beta1=true,apps/v1beta2=true,extensions/v1beta1/daemonsets=true,extensions/v1beta1/deployments=true,extensions/v1beta1/replicasets=true,extensions/v1beta1/networkpolicies=true,extensions/v1beta1/podsecuritypolicies=true" bash -s - &
wait $!

wait 120 # Give k3s installer some extra time to finish

mkdir /home/.kube/
mkdir /root/.kube/
cp /etc/rancher/k3s/k3s.yaml /home/vagrant/.kube/config
cp /etc/rancher/k3s/k3s.yaml /root/.kube/config

chown vagrant:vagrant -R /home/vagrant/.kube/