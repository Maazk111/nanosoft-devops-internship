#!/usr/bin/env bash
set -euo pipefail

cd /vagrant
mkdir -p results

echo "===== STEP 1: Verify logging driver (json-file) ====="
docker info | grep -A5 "Logging Driver" | tee results/01_docker_logging.txt

echo "===== STEP 2: Start stack (Loki+Promtail+Grafana) ====="
/vagrant/scripts/stack_up.sh

echo "===== STEP 3: Start sample log app ====="
/vagrant/app/app.sh

echo "===== STEP 4: Trigger log rotation ====="
/vagrant/scripts/rotate_test.sh

echo "===== STEP 5: Verify outputs ====="
/vagrant/scripts/verify.sh

echo "✅ DONE. Check results in: /vagrant/results"
echo "Grafana: http://localhost:3000  (admin/admin)"
echo 'In Grafana Explore, run: {job="docker"}'
