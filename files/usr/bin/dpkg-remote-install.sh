#!/bin/bash -e

mkdir /tmp/install && cd /tmp/install
wget -q $1 -O package.deb
dpkg -i package.deb || true
apt-get -y -f install
rm package.deb
