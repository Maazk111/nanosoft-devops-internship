#!/usr/bin/env bash
set -e

RABBIT_COOKIE="MYRABBITCOOKIE123"
ADMIN_USER="admin"
ADMIN_PASS="admin123"

echo "[1/9] Update + deps..."
sudo apt-get update -y
sudo apt-get install -y curl gnupg apt-transport-https ca-certificates

echo "[2/9] Ensure hostnames resolve (Erlang requirement)..."
sudo tee /etc/hosts >/dev/null <<EOF
127.0.0.1 localhost
192.168.56.21 rabbit1
192.168.56.22 rabbit2
192.168.56.23 rabbit3
EOF

echo "[3/9] Install RabbitMQ (Ubuntu 16.04 repo version)..."
sudo apt-get install -y rabbitmq-server

echo "[4/9] Enable management plugin..."
sudo rabbitmq-plugins enable rabbitmq_management

echo "[5/9] Stop service to set Erlang cookie..."
sudo systemctl stop rabbitmq-server || sudo service rabbitmq-server stop

echo "[6/9] Set SAME Erlang cookie on all nodes..."
echo "$RABBIT_COOKIE" | sudo tee /var/lib/rabbitmq/.erlang.cookie >/dev/null
sudo chown rabbitmq:rabbitmq /var/lib/rabbitmq/.erlang.cookie
sudo chmod 400 /var/lib/rabbitmq/.erlang.cookie

echo "[7/9] Start RabbitMQ..."
sudo systemctl start rabbitmq-server || sudo service rabbitmq-server start
sleep 5

echo "[8/9] Create admin user (idempotent)..."
sudo rabbitmqctl add_user "$ADMIN_USER" "$ADMIN_PASS" 2>/dev/null || true
sudo rabbitmqctl set_user_tags "$ADMIN_USER" administrator
sudo rabbitmqctl set_permissions -p / "$ADMIN_USER" ".*" ".*" ".*"

echo "[9/9] Cluster status..."
sudo rabbitmqctl cluster_status
echo "Rabbit1 ready. UI: http://192.168.56.21:15672  (admin/admin123)"