#!/bin/bash

## Script for Ubuntu 18.04
DIR=$(pwd)

# Intial setup
[ -d ~/.terraform.d/plugins ] || mkdir -p ~/.terraform.d/plugins

# Golagn install
if [ -z $(which go) ]; then
    echo "export PATH=$PATH:/usr/local/go/bin" | tee -a ~/.bashrc
    echo "export GOPATH=/home/$(whoami)/go" | tee -a ~/.bashrc
    source ~/.bashrc
    wget https://golang.org/dl/go1.15.2.linux-amd64.tar.gz
    sudo tar -C /usr/local -xzf go1.15.2.linux-amd64.tar.gz
    rm go1.15.2.linux-amd64.tar.gz
fi

# Dependencies
sudo apt update >/dev/null 2>&1
sudo apt install -y ovn-host ov-central build-essential unzip openvswitch-common lxd lxd-tools git openvswitch-switch >/dev/null 2>&1

# Terraform installation
wget -q -O terraform.zip https://releases.hashicorp.com/terraform/0.12.29/terraform_0.12.29_linux_amd64.zip
unzip terraform.zip
sudo cp terraform /usr/bin/
sudo chmod +x /usr/bin/terraform

# Terraform provider setup
wget -q -O lxd.zip https://github.com/sl1pm4t/terraform-provider-lxd/releases/download/v1.3.0/terraform-provider-lxd_v1.3.0_linux_amd64.zip
unzip -d ~/.terraform.d/plugins lxd.zip

# OpenVSwitch Provider Setup
git clone https://github.com/trvon/terraform-provider-openvswitch /tmp/openvswitch-provider
cd /tmp/openvswitch-provider
make
cp ~/go/bin/terraform-provider-openvswitch ~/.terraform.d/plugins/

FILE="~/.ssh/*.pub"
if test -f "$FILE"; then
    cp ~/.ssh/*.pub ./configs/ssh_key
else
    echo "Generate an sshkey and copy it to the file configs/ssh-key"
fi

echo "Cleaning up... "
rm terraform*
rm lxd.zip

# LXD initialization
echo "Run LXD init"

cat <<EOF | lxd init --preseed
config:
  core.https_address: '[::]:8443'
  core.trust_password: password
networks: []
storage_pools:
- config:
    size: 100GB
  description: ""
  name: default
  driver: btrfs
profiles:
- config: {}
  description: ""
  devices:
    root:
      path: /
      pool: default
      type: disk
  name: default
cluster: null
EOF
lxc remote add master-zone localhost --password password --accept-certificates

# Openvswitch
sudo ovs-vsctl set-manager ptcp:6640

echo "$(whoami) ALL=(ALL) NOPASSWD:/usr/bin/ovs-vsctl,/usr/bin/ovs-ofctl,/sbin/ip" | sudo tee -a /etc/sudoers
