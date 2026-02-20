#!/usr/bin/env bash
set -euo pipefail

# A chatty container (logs continuously)
docker rm -f log-app >/dev/null 2>&1 || true

docker run -d --name log-app alpine sh -c '
  i=1
  while true; do
    echo "$(date -Iseconds) INFO Hello from log-app line=$i"
    i=$((i+1))
    sleep 1
  done
'
