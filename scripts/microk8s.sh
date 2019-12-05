#!/bin/bash -eux

export DEBIAN_FRONTEND=noninteractive

# Prep snapd explicitly
apt-get update
apt-get upgrade -qq -y
apt-get install -y snapd curl

# Set auto refresh to a more convenient time frame, https://snapcraft.io/docs/keeping-snaps-up-to-date
snap set system refresh.timer=fri5,23:00-01:00

# Install microk8s
# https://microk8s.io/
# Zero-ops single node Kubernetes cluster for workstations and appliances
snap install microk8s --classic --channel=1.16/stable

echo "Re-enabeling deprecated K8S APIs..."
microk8s.stop
echo '' >> /var/snap/microk8s/current/args/kube-apiserver
echo '# Re-enable deprecated APIs' >> /var/snap/microk8s/current/args/kube-apiserver
echo '--runtime-config=apps/v1beta1=true,apps/v1beta2=true,extensions/v1beta1/daemonsets=true,extensions/v1beta1/deployments=true,extensions/v1beta1/replicasets=true,extensions/v1beta1/networkpolicies=true,extensions/v1beta1/podsecuritypolicies=true' >> /var/snap/microk8s/current/args/kube-apiserver
echo '#~Re-enable deprecated APIs' >> /var/snap/microk8s/current/args/kube-apiserver

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
curl -sSLo /tmp/helm3.tar.gz https://get.helm.sh/helm-v3.0.0-linux-amd64.tar.gz
tar -xzvf /tmp/helm3.tar.gz
mv /tmp/linux-amd64/helm /usr/local/bin/helm
chmod +x /usr/local/bin/helm
ln -s /usr/local/bin/helm /usr/local/bin/helm3

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