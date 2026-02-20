#!/usr/bin/env bash
set -euo pipefail

COOKIE="RABBITCLUSTER123"

HOST="$(hostname -s)"                    # rabbitmq-ubuntu
NODE1="rabbit@${HOST}"                   # rabbit@rabbitmq-ubuntu
NODE2_HOST="${HOST}-node2"               # rabbitmq-ubuntu-node2
NODE2="rabbit@${NODE2_HOST}"             # rabbit@rabbitmq-ubuntu-node2

NODE2_AMQP_PORT="5673"
NODE2_DIST_PORT="25682"                 # fixed Erlang distribution port for node2
NODE2_MNESIA="/var/lib/rabbitmq-node2"
NODE2_LOG="/var/log/rabbitmq-node2"

echo "[1/10] Install Erlang + RabbitMQ from Ubuntu repos..."
sudo apt-get update -y
sudo apt-get install -y erlang rabbitmq-server

echo "[2/10] Ensure hostnames resolve (Erlang requirement)..."
# add only if not already present
if ! grep -q "${HOST}" /etc/hosts; then
  echo "127.0.0.1 ${HOST}" | sudo tee -a /etc/hosts >/dev/null
fi
if ! grep -q "${NODE2_HOST}" /etc/hosts; then
  echo "127.0.0.1 ${NODE2_HOST}" | sudo tee -a /etc/hosts >/dev/null
fi

echo "[3/10] Enable management plugin..."
sudo rabbitmq-plugins enable rabbitmq_management

echo "[4/10] Stop node1 to safely set cookie..."
sudo systemctl stop rabbitmq-server || true

echo "[5/10] Configure Erlang cookie (same for ALL nodes)..."
echo "${COOKIE}" | sudo tee /var/lib/rabbitmq/.erlang.cookie >/dev/null
sudo chmod 400 /var/lib/rabbitmq/.erlang.cookie
sudo chown rabbitmq:rabbitmq /var/lib/rabbitmq/.erlang.cookie

echo "[6/10] Start node1 service..."
sudo systemctl start rabbitmq-server
sleep 6

echo "[7/10] Prepare node2 dirs..."
sudo mkdir -p "${NODE2_MNESIA}" "${NODE2_LOG}"
sudo chown -R rabbitmq:rabbitmq "${NODE2_MNESIA}" "${NODE2_LOG}"

echo "[8/10] Cleanup any previous node2 instance (if running)..."
sudo -u rabbitmq RABBITMQ_USE_LONGNAME=true RABBITMQ_NODENAME="${NODE2}" rabbitmqctl stop_app >/dev/null 2>&1 || true
sudo pkill -f "rabbitmq.*${NODE2_HOST}" >/dev/null 2>&1 || true
sleep 2

echo "[9/10] Start node2 (detached) with fixed AMQP + fixed dist port..."
set +e
sudo -u rabbitmq \
  RABBITMQ_USE_LONGNAME=true \
  RABBITMQ_NODENAME="${NODE2}" \
  RABBITMQ_NODE_PORT="${NODE2_AMQP_PORT}" \
  RABBITMQ_MNESIA_BASE="${NODE2_MNESIA}" \
  RABBITMQ_LOG_BASE="${NODE2_LOG}" \
  RABBITMQ_SERVER_ADDITIONAL_ERL_ARGS="-kernel inet_dist_listen_min ${NODE2_DIST_PORT} inet_dist_listen_max ${NODE2_DIST_PORT}" \
  rabbitmq-server -detached
RC=$?
set -e

if [ $RC -ne 0 ]; then
  echo "❌ Node2 failed to start. Showing node2 logs for debugging:"
  sudo ls -la "${NODE2_LOG}" || true
  sudo tail -n 120 "${NODE2_LOG}"/*.log 2>/dev/null || true
  exit 1
fi

sleep 8

echo "[10/10] Join node2 to node1 cluster..."
sudo -u rabbitmq RABBITMQ_USE_LONGNAME=true RABBITMQ_NODENAME="${NODE2}" rabbitmqctl stop_app
sudo -u rabbitmq RABBITMQ_USE_LONGNAME=true RABBITMQ_NODENAME="${NODE2}" rabbitmqctl reset
sudo -u rabbitmq RABBITMQ_USE_LONGNAME=true RABBITMQ_NODENAME="${NODE2}" rabbitmqctl join_cluster "${NODE1}"
sudo -u rabbitmq RABBITMQ_USE_LONGNAME=true RABBITMQ_NODENAME="${NODE2}" rabbitmqctl start_app

echo
echo "✅ RabbitMQ cluster ready on ONE VM (2 nodes)!"
echo "Node1: ${NODE1}  (AMQP 5672, dist 25672)"
echo "Node2: ${NODE2}  (AMQP ${NODE2_AMQP_PORT}, dist ${NODE2_DIST_PORT})"
echo "Management UI: http://192.168.56.12:15672 (guest/guest)"
echo
echo "=== Cluster Status (Proof) ==="
sudo rabbitmqctl cluster_status