#!/bin/bash -e

INSTALL_DIR=$(mktemp -d)

[[ ! -d $INSTALL_DIR ]] && mkdir $INSTALL_DIR
cd $INSTALL_DIR
wget -q $1 -O package.deb
dpkg -i package.deb || true
apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"  -y -f install
rm package.deb
