#!/usr/bin/env bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

echo "[1/7] Update & install dependencies..."
apt-get update -y
apt-get install -y ca-certificates curl gnupg lsb-release apt-transport-https \
  iproute2 iputils-ping net-tools tcpdump jq

echo "[2/7] Install Docker Engine (official repo)..."
install -m 0755 -d /etc/apt/keyrings

if [ ! -f /etc/apt/keyrings/docker.gpg ]; then
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  chmod a+r /etc/apt/keyrings/docker.gpg
fi

UBUNTU_CODENAME="$(. /etc/os-release && echo "$VERSION_CODENAME")"

cat >/etc/apt/sources.list.d/docker.list <<EOF
deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu ${UBUNTU_CODENAME} stable
EOF

apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "[3/7] Enable Docker service..."
systemctl enable --now docker

echo "[4/7] Add vagrant user to docker group..."
usermod -aG docker vagrant || true

echo "[5/7] Prepare Week7 lab directory..."
mkdir -p /home/vagrant/week7-networking/results
cp -f /vagrant/run_all.sh /home/vagrant/week7-networking/run_all.sh
cp -f /vagrant/cleanup.sh /home/vagrant/week7-networking/cleanup.sh
chown -R vagrant:vagrant /home/vagrant/week7-networking
chmod +x /home/vagrant/week7-networking/*.sh

echo "[6/7] Pull required images (faster later)..."
docker pull alpine:latest >/dev/null
docker pull python:3.11-alpine >/dev/null
docker pull nicolaka/netshoot:latest >/dev/null

echo "[7/7] Done. IMPORTANT:"
echo " - Re-login SSH so docker group applies: 'vagrant ssh' again"
echo " - Then run: sudo /home/vagrant/week7-networking/run_all.sh"
