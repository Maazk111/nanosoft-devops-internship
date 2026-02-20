#!/usr/bin/env bash
set -e

RABBIT_COOKIE="MYRABBITCOOKIE123"

echo "[1/10] Update + deps..."
sudo apt-get update -y
sudo apt-get install -y curl gnupg apt-transport-https ca-certificates

echo "[2/10] Ensure hostnames resolve..."
sudo tee /etc/hosts >/dev/null <<EOF
127.0.0.1 localhost
192.168.56.21 rabbit1
192.168.56.22 rabbit2
192.168.56.23 rabbit3
EOF

echo "[3/10] Install RabbitMQ..."
sudo apt-get install -y rabbitmq-server

echo "[4/10] Enable management plugin..."
sudo rabbitmq-plugins enable rabbitmq_management

echo "[5/10] Stop service to set cookie..."
sudo systemctl stop rabbitmq-server || sudo service rabbitmq-server stop

echo "[6/10] Set SAME Erlang cookie..."
echo "$RABBIT_COOKIE" | sudo tee /var/lib/rabbitmq/.erlang.cookie >/dev/null
sudo chown rabbitmq:rabbitmq /var/lib/rabbitmq/.erlang.cookie
sudo chmod 400 /var/lib/rabbitmq/.erlang.cookie

echo "[7/10] Start RabbitMQ..."
sudo systemctl start rabbitmq-server || sudo service rabbitmq-server start
sleep 5

echo "[8/10] Join cluster with rabbit1..."
sudo rabbitmqctl stop_app
sudo rabbitmqctl reset
sudo rabbitmqctl join_cluster rabbit@rabbit1
sudo rabbitmqctl start_app

echo "[9/10] Cluster status..."
sudo rabbitmqctl cluster_status

echo "[10/10] Done. UI: http://192.168.56.23:15672"