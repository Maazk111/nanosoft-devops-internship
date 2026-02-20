#!/usr/bin/env bash
set -euo pipefail

SRC="/vagrant/docker/daemon.json"
DST="/etc/docker/daemon.json"

echo "[PROVISION] Configuring Docker logging driver + rotation..."
sudo mkdir -p /etc/docker
sudo cp -f "$SRC" "$DST"

echo "[PROVISION] daemon.json applied:"
sudo cat "$DST"

echo "[PROVISION] Restarting Docker..."
sudo systemctl restart docker

echo "[PROVISION] Verify logging driver:"
docker info | grep -A2 "Logging Driver" || true

echo "[PROVISION] Done."