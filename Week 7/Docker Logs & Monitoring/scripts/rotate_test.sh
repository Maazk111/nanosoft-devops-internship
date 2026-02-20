#!/usr/bin/env bash
set -euo pipefail

mkdir -p /vagrant/results

echo "[ROTATE] Creating a heavy log container to trigger rotation..."
docker rm -f rotate-test >/dev/null 2>&1 || true

docker run -d --name rotate-test alpine sh -c '
  # Generate lots of logs fast
  i=1
  while true; do
    echo "$(date -Iseconds) WARN ROTATE_TEST payload=$(head -c 2000 /dev/urandom | base64 | tr -d "\n") line=$i"
    i=$((i+1))
    sleep 0.05
  done
'

echo "[ROTATE] Waiting 15 seconds..."
sleep 15

CID="$(docker inspect -f '{{.Id}}' rotate-test)"
LOGDIR="/var/lib/docker/containers/${CID}"
echo "[ROTATE] Container log dir: ${LOGDIR}"

echo "[ROTATE] Listing log files (you should see .log + .log.1 etc)..."
sudo ls -lah "${LOGDIR}" | tee /vagrant/results/02_log_rotation.txt

echo "[ROTATE] Done."
