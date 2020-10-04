#!/bin/bash

# Adding Salt repository
wget -O - https://repo.saltstack.com/apt/ubuntu/18.04/amd64/latest/SALTSTACK-GPG-KEY.pub | sudo apt-key add -
echo "deb http://repo.saltstack.com/apt/ubuntu/18.04/amd64/latest bionic main" | tee -a /etc/apt/sources.list.d/saltstack.list

# Establish location of salt master
echo "\n10.0.0.5\tmaster" | tee -a /etc/hosts

# Wait
sleep 2

# Getting Updates and Installing python
apt-get update >/dev/null 2>&1
apt-get install python3-dev python3-pip python3 python-pylxd salt-minion lxd-tools -y >/dev/null 2>&1

# Seeding lxd init
cat <<EOF | lxd init --preseed
config:
  core.https_address: '[::]:8443'
  core.trust_password: password
networks: []
storage_pools:
- config:
    source: /var/lib/lxd/storage-pools/default
  description: ""
  name: default
  driver: btrfs
profiles:
- config:
    security.privileged: "false"
  description: ""
  devices:
    root:
      path: /
      pool: default
      type: disk
  name: default
cluster: null
EOF

systemctl start salt-minion
systemctl enable salt-minion

# Remove self
rm /root/minion.sh
