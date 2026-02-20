#!/usr/bin/env bash
set -euo pipefail

OUT_DIR="/home/vagrant/week7-networking/results"
mkdir -p "$OUT_DIR"

log() { echo -e "\n===== $1 =====\n"; }

# run(): logs the command and its output into the current log file
run() {
  echo "+ $*" | tee -a "$CURRENT_LOG"
  eval "$@" 2>&1 | tee -a "$CURRENT_LOG"
}

require_docker() {
  if ! command -v docker >/dev/null 2>&1; then
    echo "Docker not found. Provisioning failed." >&2
    exit 1
  fi
  sudo docker info >/dev/null 2>&1 || { echo "Docker daemon not reachable." >&2; exit 1; }
}

cleanup_leftovers() {
  sudo docker rm -f c1 c2 hostweb bridgeweb >/dev/null 2>&1 || true
  sudo docker service rm s1 s2 >/dev/null 2>&1 || true
  sudo docker network rm mybridge1 mybridge2 myoverlay1 >/dev/null 2>&1 || true
}

require_docker
cleanup_leftovers

# -------------------------
# 1) Create Networks
# -------------------------
CURRENT_LOG="$OUT_DIR/00_networks.txt"
: > "$CURRENT_LOG"
log "Create networks" | tee -a "$CURRENT_LOG"

run "sudo docker network create --driver bridge mybridge1"
run "sudo docker network create --driver bridge mybridge2"

# Swarm init (overlay needs it)
if ! sudo docker info 2>/dev/null | grep -qi 'Swarm: active'; then
  run "sudo docker swarm init --advertise-addr 192.168.56.77 || sudo docker swarm init"
fi

# ✅ FIX: create overlay as attachable so docker run can join it
run "sudo docker network create --driver overlay --attachable myoverlay1"

run "sudo docker network ls"

# ✅ FIX: avoid pipefail abort due to SIGPIPE from head
run "sudo docker network inspect mybridge1 --format '{{json .}}' | jq . | head -n 60 || true"
run "sudo docker network inspect myoverlay1 --format '{{json .}}' | jq . | head -n 60 || true"

# -------------------------
# 2) Isolation Test
# -------------------------
CURRENT_LOG="$OUT_DIR/01_isolation_test.txt"
: > "$CURRENT_LOG"
log "Isolation test (different bridge networks cannot talk)" | tee -a "$CURRENT_LOG"

run "sudo docker run -d --name c1 --network mybridge1 alpine sleep 1d"
run "sudo docker run -d --name c2 --network mybridge2 alpine sleep 1d"

C1_IP="$(sudo docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' c1)"
C2_IP="$(sudo docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' c2)"

echo "c1 IP (mybridge1): $C1_IP" | tee -a "$CURRENT_LOG"
echo "c2 IP (mybridge2): $C2_IP" | tee -a "$CURRENT_LOG"

# Expected failure
set +e
sudo docker exec c1 ping -c 2 "$C2_IP" >/dev/null 2>&1
PING_RC=$?
set -e
echo "Ping c1 -> c2_ip exit code: $PING_RC (expected non-zero)" | tee -a "$CURRENT_LOG"

# -------------------------
# 3) Enable Communication
# -------------------------
CURRENT_LOG="$OUT_DIR/02_connectivity_fixed.txt"
: > "$CURRENT_LOG"
log "Fix connectivity (connect c2 to mybridge1)" | tee -a "$CURRENT_LOG"

run "sudo docker network connect mybridge1 c2"
C2_BR1_IP="$(sudo docker inspect -f '{{.NetworkSettings.Networks.mybridge1.IPAddress}}' c2)"
echo "c2 IP on mybridge1: $C2_BR1_IP" | tee -a "$CURRENT_LOG"

run "sudo docker exec c1 ping -c 2 $C2_BR1_IP"
run "sudo docker exec c1 ping -c 2 c2"

# -------------------------
# 4) Host Network Demo
# -------------------------
CURRENT_LOG="$OUT_DIR/03_host_network_test.txt"
: > "$CURRENT_LOG"
log "Host network demo" | tee -a "$CURRENT_LOG"

run "sudo docker rm -f hostweb >/dev/null 2>&1 || true"
run "sudo docker run -d --name hostweb --network host python:3.11-alpine sh -c 'python -m http.server 8080'"

# verify from VM itself
run "curl -I http://127.0.0.1:8080 | head -n 20 || true"

# bridge without -p should NOT be reachable from host
run "sudo docker rm -f bridgeweb >/dev/null 2>&1 || true"
run "sudo docker run -d --name bridgeweb --network mybridge1 python:3.11-alpine sh -c 'python -m http.server 8081'"

set +e
curl -I http://127.0.0.1:8081 >/dev/null 2>&1
CURL_RC=$?
set -e
echo "curl 127.0.0.1:8081 exit code: $CURL_RC (expected non-zero)" | tee -a "$CURRENT_LOG"

# -------------------------
# 5) Overlay Network Test
# -------------------------
CURRENT_LOG="$OUT_DIR/04_overlay_test.txt"
: > "$CURRENT_LOG"
log "Overlay network test (Swarm services + attachable overlay)" | tee -a "$CURRENT_LOG"

run "sudo docker service create --name s1 --network myoverlay1 alpine sleep 1d"
run "sudo docker service create --name s2 --network myoverlay1 alpine sleep 1d"

# Wait a bit for services to stabilize (simple verify loop)
for i in {1..10}; do
  READY1="$(sudo docker service ps s1 --no-trunc 2>/dev/null | awk 'NR>1{print $6}' | head -n1 || true)"
  READY2="$(sudo docker service ps s2 --no-trunc 2>/dev/null | awk 'NR>1{print $6}' | head -n1 || true)"
  if [[ "$READY1" == "Running" && "$READY2" == "Running" ]]; then
    break
  fi
  echo "verify: Waiting 3 seconds to verify that tasks are stable..." | tee -a "$CURRENT_LOG"
  sleep 3
done

run "sudo docker service ls"
run "sudo docker service ps s1"
run "sudo docker service ps s2"

# Now docker run can attach because overlay is attachable ✅
run "sudo docker run --rm --network myoverlay1 alpine sh -c 'ping -c 2 s1 && ping -c 2 s2'"

# -------------------------
# 6) tcpdump Capture
# -------------------------
CURRENT_LOG="$OUT_DIR/05_tcpdump_output.txt"
: > "$CURRENT_LOG"
log "tcpdump capture (ICMP on bridge interface)" | tee -a "$CURRENT_LOG"

NET_ID="$(sudo docker network inspect mybridge1 -f '{{.Id}}' | cut -c1-12)"
BR_IF="br-${NET_ID}"

echo "Detected mybridge1 id: $NET_ID" | tee -a "$CURRENT_LOG"
echo "Assuming bridge interface: $BR_IF" | tee -a "$CURRENT_LOG"

if ! ip link show "$BR_IF" >/dev/null 2>&1; then
  echo "Bridge interface $BR_IF not found. Listing br-* interfaces:" | tee -a "$CURRENT_LOG"
  ip link | grep -E 'br-' | tee -a "$CURRENT_LOG"
fi

PCAP="$OUT_DIR/icmp_capture.pcap"

# Start capture (background)
sudo timeout 8 tcpdump -i "$BR_IF" -w "$PCAP" icmp >/dev/null 2>&1 &
TCPDUMP_PID=$!
sleep 1

# Generate ICMP traffic on mybridge1 (name resolves because both are on mybridge1 now)
run "sudo docker exec c1 ping -c 4 c2"

wait $TCPDUMP_PID || true
echo "Saved pcap: $PCAP" | tee -a "$CURRENT_LOG"
ls -lh "$PCAP" | tee -a "$CURRENT_LOG"

# -------------------------
# Summary
# -------------------------
SUMMARY="$OUT_DIR/SUMMARY.txt"
cat > "$SUMMARY" <<EOF
Week7 Docker Networking Deep Dive - Automated Lab Completed

Outputs saved in:
  $OUT_DIR

Files:
  00_networks.txt
  01_isolation_test.txt
  02_connectivity_fixed.txt
  03_host_network_test.txt
  04_overlay_test.txt
  05_tcpdump_output.txt
  icmp_capture.pcap

How to view pcap quickly:
  sudo tcpdump -r $OUT_DIR/icmp_capture.pcap | head
EOF

echo -e "\n✅ DONE. Check results in: $OUT_DIR\n"