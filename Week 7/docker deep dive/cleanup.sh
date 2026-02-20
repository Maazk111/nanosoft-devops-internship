#!/usr/bin/env bash
set -euo pipefail

echo "Cleaning containers, services, networks, swarm..."

sudo docker rm -f c1 c2 hostweb bridgeweb >/dev/null 2>&1 || true
sudo docker service rm s1 s2 >/dev/null 2>&1 || true

sudo docker network rm mybridge1 mybridge2 myoverlay1 >/dev/null 2>&1 || true

# Leave swarm (force)
sudo docker swarm leave --force >/dev/null 2>&1 || true

echo "✅ Cleanup done."