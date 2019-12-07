#!/usr/bin/env bash

set -euo pipefail

function cleanup() {
    rm http/preseed.cfg
}

trap cleanup EXIT

if [[ -z "${ROOT_SSH_PASSWORD}" ]]; then
    echo "ROOT_SSH_PASSWORD is required"
    exit 1
fi

if [[ -z "${SSH_PASSWORD}" ]]; then
    echo "SSH_PASSWORD is required"
    exit 1
fi

if [[ -z "${PROXMOX_PASSWORD}" ]]; then
    echo "PROXMOX_PASSWORD is required"
    exit 1
fi

if [[ -z "${PROXMOX_HOST}" ]]; then
    echo "PROXMOX_HOST is required"
    exit 1
fi

export HTTPIP=$(ipconfig getifaddr en0)

mkdir -p keys

if [[ ! -f "keys/rke" ]]; then
    echo "Generating SSH keys..."
    ssh-keygen -t rsa -b 4096 -C "rke" -N ''
fi

packer validate ubuntu.json

gomplate -f http/preseed.cfg.tmpl -o http/preseed.cfg
packer build ubuntu.json
