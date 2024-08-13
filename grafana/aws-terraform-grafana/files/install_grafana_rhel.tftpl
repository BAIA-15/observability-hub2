#!/bin/bash

## https://grafana.com/docs/grafana/latest/setup-grafana/installation/redhat-rhel-fedora/

# sudo
sudo -s

# update all installed packages
yum update -v -y

# set environmental variables
export GF_SECURITY_ADMIN_PASSWORD="taxi"
# echo $GF_SECURITY_ADMIN_PASSWORD

# stop and uninstall grafana
# systemctl stop grafana-server
# dnf remove grafana-enterprise
# rm -i /etc/yum.repos.d/grafana.repo -y

# import the GPG key
wget -q -O gpg.key https://rpm.grafana.com/gpg.key
rpm --import gpg.key

# add a new yum respository to download grafana
cat >> /etc/yum.repos.d/grafana.repo <<EOF
[grafana]
name=grafana
baseurl=https://rpm.grafana.com
repo_gpgcheck=1
enabled=1
gpgcheck=1
gpgkey=https://rpm.grafana.com/gpg.key
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
EOF

# install grafana enterprise
dnf install grafana-enterprise -v -y

## https://grafana.com/docs/grafana/latest/setup-grafana/start-restart-grafana/

# reload systemd to load new settings
systemctl daemon-reload

# start the grafana server
systemctl start grafana-server

# verify grafana server is running
systemctl status grafana-server -l --no-pager

# load grafana on EC2 boot
systemctl enable grafana-server.service
