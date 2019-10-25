#!/bin/bash -eux

export DEBIAN_FRONTEND=noninteractive

# Prep snapd explicitly
apt-get update
apt-get upgrade -qq -y
apt-get install -y snapd

# Install microk8s
# https://microk8s.io/
# Zero-ops single node Kubernetes cluster for workstations and appliances
snap install microk8s --classic --channel=1.15/stable

microk8s.start
microk8s.status --wait-ready
microk8s.enable dns 
microk8s.status --wait-ready
microk8s.enable storage dashboard
microk8s.status --wait-ready

# .kube/config is needed for tools like stern to operate on the cluster
mkdir -p					/home/vagrant/.kube/
chmod 750					/home/vagrant/.kube/
microk8s.config >     		/home/vagrant/.kube/config             
chmod 664             		/home/vagrant/.kube/config
chown -R vagrant:vagrant	/home/vagrant/.kube/

mkdir -p					/root/.kube/
chmod 750					/root/.kube/
microk8s.config >     		/root/.kube/config             
chmod 664             		/root/.kube/config
chown -R vagrant:vagrant	/root/.kube/

snap alias microk8s.kubectl kubectl

# Add user vagrant to the new group 'microk8s'. A reload is required to make this work.
usermod -a -G microk8s vagrant

# Install helm
# https://helm.sh/
# Helm helps you manage Kubernetes applications  Helm Charts help you define, install, and upgrade even the most complex Kubernetes application.
pushd /tmp
curl -sSLo /tmp/helm3.tar.gz https://get.helm.sh/helm-v3.0.0-beta.5-linux-amd64.tar.gz
tar -xzvf /tmp/helm3.tar.gz
mv /tmp/linux-amd64/helm /usr/local/bin/helm
chmod +x /usr/local/bin/helm

rm /tmp/helm3.tar.gz
rm -rf /tmp/linux-amd64/
popd

# Install stern
# https://github.com/wercker/stern
# Stern allows you to tail multiple pods on Kubernetes and multiple containers within the pod.
curl -sSLo stern https://github.com/wercker/stern/releases/download/1.11.0/stern_linux_amd64
chmod 555 stern
sudo chown root:root stern
sudo mv stern /usr/local/bin/