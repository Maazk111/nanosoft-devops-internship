#!/usr/bin/env bash
set -euo pipefail
mkdir -p /vagrant/results

echo "==== Verify: Docker logging driver ====" | tee /vagrant/results/01_docker_logging.txt
docker info | grep -A5 "Logging Driver" | tee -a /vagrant/results/01_docker_logging.txt
echo "" | tee -a /vagrant/results/01_docker_logging.txt
echo "daemon.json:" | tee -a /vagrant/results/01_docker_logging.txt
sudo cat /etc/docker/daemon.json | tee -a /vagrant/results/01_docker_logging.txt

echo "==== Verify: Stack running ====" | tee /vagrant/results/03_loki_running.txt
docker compose -f /vagrant/docker/docker-compose.yml ps | tee -a /vagrant/results/03_loki_running.txt

echo "==== Verify: App logs exist locally (json-file) ====" | tee /vagrant/results/04_grafana_logs.txt
docker logs --tail 10 log-app | tee -a /vagrant/results/04_grafana_logs.txt

cat > /vagrant/results/SUMMARY.txt <<'EOF'
Week7 Docker Logs & Monitoring - Proof Summary

1) json-file logging driver configured via /etc/docker/daemon.json
   - log-opts: max-size=5m, max-file=3 (rotation)

2) Log rotation test:
   - rotate-test container creates heavy logs
   - verify rotated files in /var/lib/docker/containers/<id>/

3) Centralized logs:
   - Loki stores logs
   - Promtail ships docker json logs to Loki
   - Grafana visualizes Loki datasource (auto-provisioned)

Grafana:
- URL: http://localhost:3000
- user/pass: admin/admin
- Explore -> Loki -> query: {job="docker"}
EOF

echo "[VERIFY] Done. Results in /vagrant/results"
