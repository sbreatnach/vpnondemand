#!/bin/bash

VPN_BUCKET=%%VPN_BUCKET%%

sudo su
apt update
apt install openvpn easy-rsa

aws s3 cp s3://${VPN_BUCKET}/extra_data.tar.gz /tmp/extra_data.tar.gz
tar -xzf /tmp/extra_data.tar.gz

mkdir /etc/openvpn/easy-rsa/
cp -r /usr/share/easy-rsa/* /etc/openvpn/easy-rsa/
cp /tmp/easy_rsa_vars.sh /etc/openvpn/easy-rsa/vars

cd /etc/openvpn/easy-rsa/ && source vars && ./clean-all && ./build-ca && ./build-key-server
