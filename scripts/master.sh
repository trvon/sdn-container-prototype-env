#/bin/bash

# Sleep until internet
until ping -c 1 1.1.1.1 >/dev/null 2>&1; do
    sleep 1
done

## SaltStack Repo
wget -O - https://repo.saltstack.com/py3/ubuntu/18.04/amd64/latest/SALTSTACK-GPG-KEY.pub | sudo apt-key add -
echo "deb http://repo.saltstack.com/py3/ubuntu/18.04/amd64/latest bionic main" | tee /etc/apt/sources.list.d/saltstack.list
apt update >/dev/null 2>&1

## Dependency installation
DEBIAN_FRONTEND=noninteractive apt-get install lxd-tools build-essential libpcap-dev libpcre3-dev libnet1-dev zlib1g-dev luajit \
		hwloc libdnet-dev libdumbnet-dev bison flex liblzma-dev openssl libssl-dev pkg-config libhwloc-dev cmake cpputest \
		libsqlite3-dev uuid-dev libcmocka-dev libnetfilter-queue-dev libmnl-dev autotools-dev libluajit-5.1-dev \
		libunwind-dev libtcmalloc-minimal4 git dh-autoreconf -yq >/dev/null 2>&1

## Snort Install
# Daq library
git clone https://github.com/snort3/libdaq.git /tmp/snort-files
cd /tmp/snort-files/
./bootstrap 1>/dev/null
./configure 1>/dev/null
make 1>/dev/null; make install 1>/dev/null

# Google thread-caching
wget -P /tmp https://github.com/gperftools/gperftools/releases/download/gperftools-2.8/gperftools-2.8.tar.gz
tar xf /tmp/gperftools-2.8.tar.gz -C /tmp
cd /tmp/gperftools-2.8
./configure 1>/dev/null
make 1>/dev/null; make install 1>/dev/null
ln -s /usr/local/lib/libtcmalloc.so.4 /usr/lib/

# Snort application
git clone https://github.com/snort3/snort3.git /tmp/snort-package
cd /tmp/snort-package
./configure_cmake.sh --enable-tcmalloc
cd build
make -j $(nproc) install
ln -s /usr/local/snort/bin/snort /usr/bin/

# Snort extras
git clone https://github.com/snort3/snort3_extra.git /tmp/snort-extra
cd /tmp/snort-extra
export PKG_CONFIG_PATH=/usr/local/snort/lib/pkgconfig/
./configure_cmake.sh 
cd build
make -j$(nproc)
make -j$(nproc) install

# Network Intrusion Detection
ip link set dev eth0 promisc on


# Install salt
apt install salt-master python3-pip python3 -y >/dev/null 2>&1

# Controller Setup
/opt/controller/build.sh

# Run custom controller code
/opt/controller/locus  >/dev/null 2>&1 &

mv /root/master /etc/salt/master

systemctl restart salt-master
systemctl enable salt-master

# Waiting for Salt minions to connect
x=$(salt-key -L | grep zone | wc -l) 
while [ $x -le 3 ]
do
    sleep 2
    x=$(salt-key -L | grep zone | wc -l) 
done
salt-key -A -y

## Sync States
salt-run fileserver.update
salt \* saltutil.sync_modules
salt \* saltutil.sync_states

# Install pop
pip3 install pop

# Snort Socket creation
mkdir /var/log/snort

# Rules population
echo "alert icmp any any -> any any (msg: \"NMAP ping sweep Scan\"; dsize:0; itype:8; reference:arachnids,162; classtype:attempted-recon; sid:469; rev:3;)" | tee /usr/local/snort/etc/snort/local.rules

# Start snort
snort -q -d -D -i eth0 -c /usr/local/snort/etc/snort/snort.lua -l /var/log/snort/ --script-path /usr/local/snort/lib/snort_extra

# Remove self
rm /root/master.sh
