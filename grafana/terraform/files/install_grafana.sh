#!/bin/bash

## https://grafana.com/docs/grafana/latest/setup-grafana/installation/redhat-rhel-fedora/

# update all installed packages
sudo yum update -y

# import the GPG key
wget -q -O gpg.key https://rpm.grafana.com/gpg.key
sudo rpm --import gpg.key

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
sudo dnf install grafana-enterprise -y

## https://grafana.com/docs/grafana/latest/setup-grafana/start-restart-grafana/

# reload systemd to load new settings
sudo systemctl daemon-reload

# start the grafana server
sudo systemctl start grafana-server

# verify grafana server is running
sudo systemctl status grafana-server -l --no-pager

# load grafana on EC2 boot
sudo systemctl enable grafana-server.service
