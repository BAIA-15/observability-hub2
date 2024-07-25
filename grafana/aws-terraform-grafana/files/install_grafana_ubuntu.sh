#!/bin/bash

## https://grafana.com/docs/grafana/latest/setup-grafana/installation/redhat-rhel-fedora/

# Install the prerequisite packages
sudo apt-get install -y apt-transport-https software-properties-common wget

# set environmental variables
export GF_SECURITY_ADMIN_PASSWORD="taxi"
# echo $GF_SECURITY_ADMIN_PASSWORD

# Import the GPG key:
sudo mkdir -p /etc/apt/keyrings/
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null

# To add a repository for stable releases
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list

# Updates the list of available packages
sudo apt-get update

# Installs the latest Enterprise release:
sudo apt-get install grafana-enterprise -y

# reload systemd to load new settings
sudo systemctl daemon-reload

# start the grafana server
systemctl start grafana-server

# verify grafana server is running
systemctl status grafana-server -l --no-pager

# load grafana on EC2 boot
systemctl enable grafana-server.service
