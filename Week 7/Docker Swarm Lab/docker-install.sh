#!/bin/bash
set -e

apt update -y
apt install -y ca-certificates curl gnupg lsb-release

curl -fsSL https://get.docker.com | sh

usermod -aG docker vagrant
systemctl enable docker
systemctl start docker
