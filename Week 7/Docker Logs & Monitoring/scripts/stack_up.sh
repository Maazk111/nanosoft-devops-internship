#!/usr/bin/env bash
set -euo pipefail

cd /vagrant

mkdir -p results
echo "[STACK] Starting Loki + Promtail + Grafana..."
docker compose -f docker/docker-compose.yml up -d

echo "[STACK] Current status:"
docker compose -f docker/docker-compose.yml ps | tee results/03_loki_running.txt
