#!/usr/bin/env bash

set -euo pipefail

## Install Docker
curl https://releases.rancher.com/install-docker/18.09.2.sh | sh

## Add rke user to docker group
usermod -aG docker rke

## Install kubectl
sudo apt-get update && sudo apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl
