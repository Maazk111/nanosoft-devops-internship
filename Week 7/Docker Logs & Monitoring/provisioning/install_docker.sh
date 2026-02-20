#!/usr/bin/env bash
set -euo pipefail

echo "[PROVISION] Updating packages..."
sudo apt-get update -y

echo "[PROVISION] Installing dependencies..."
sudo apt-get install -y ca-certificates curl gnupg lsb-release jq

echo "[PROVISION] Installing Docker (official repo)..."
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

ARCH="$(dpkg --print-architecture)"
CODENAME="$(. /etc/os-release && echo "$VERSION_CODENAME")"

echo \
  "deb [arch=${ARCH} signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu ${CODENAME} stable" \
  | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "[PROVISION] Adding vagrant user to docker group..."
sudo usermod -aG docker vagrant || true

echo "[PROVISION] Enabling Docker service..."
sudo systemctl enable docker
sudo systemctl start docker

echo "[PROVISION] Docker installed:"
docker --version || true
docker compose version || true