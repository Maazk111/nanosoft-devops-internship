#!/usr/bin/env bash
set -euo pipefail

echo "[CLEANUP] Stopping compose stack..."
docker compose -f /vagrant/docker/docker-compose.yml down || true

echo "[CLEANUP] Removing test containers..."
docker rm -f log-app rotate-test >/dev/null 2>&1 || true

echo "[CLEANUP] Done."
