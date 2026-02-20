#!/usr/bin/env bash
set -euo pipefail

MONGO_VER="3.2.5"
TARBALL="mongodb-linux-x86_64-ubuntu1404-3.2.5.tgz"
URL="https://fastdl.mongodb.org/linux/${TARBALL}"

echo "[1/7] Installing dependencies..."
sudo apt-get update -y
sudo apt-get install -y wget tar libssl1.0.0 libcurl3

echo "[2/7] Downloading MongoDB ${MONGO_VER}..."
cd /tmp
if [ ! -f "${TARBALL}" ]; then
  wget -q "${URL}"
fi

echo "[3/7] Installing MongoDB binaries..."
sudo rm -rf /opt/mongodb-${MONGO_VER}
sudo mkdir -p /opt/mongodb-${MONGO_VER}
sudo tar -xzf "${TARBALL}" -C /opt/mongodb-${MONGO_VER} --strip-components=1

# symlink binaries
sudo ln -sf /opt/mongodb-${MONGO_VER}/bin/mongod /usr/local/bin/mongod
sudo ln -sf /opt/mongodb-${MONGO_VER}/bin/mongo  /usr/local/bin/mongo

echo "[4/7] Creating data/log directories..."
for p in 27017 27018 27019; do
  sudo mkdir -p /var/lib/mongo/rs0-${p}
  sudo mkdir -p /var/log/mongodb
done

echo "[5/7] Creating config files..."
for p in 27017 27018 27019; do
  sudo tee /etc/mongod-rs0-${p}.conf >/dev/null <<EOF
systemLog:
  destination: file
  path: /var/log/mongodb/rs0-${p}.log
  logAppend: true
storage:
  dbPath: /var/lib/mongo/rs0-${p}
net:
  bindIp: 0.0.0.0
  port: ${p}
replication:
  replSetName: rs0
processManagement:
  fork: false
EOF
done

echo "[6/7] Creating systemd services..."
for p in 27017 27018 27019; do
  sudo tee /etc/systemd/system/mongod-rs0-${p}.service >/dev/null <<EOF
[Unit]
Description=MongoDB rs0 instance on port ${p}
After=network.target

[Service]
User=root
ExecStart=/usr/local/bin/mongod --config /etc/mongod-rs0-${p}.conf
Restart=always
LimitNOFILE=64000

[Install]
WantedBy=multi-user.target
EOF
done

sudo systemctl daemon-reload
for p in 27017 27018 27019; do
  sudo systemctl enable mongod-rs0-${p}
  sudo systemctl restart mongod-rs0-${p}
done

echo "[7/7] Initiating Replica Set rs0..."
# Wait a bit for mongod to be ready
sleep 5

mongo --quiet --port 27017 <<'EOF'
rs.initiate({
  _id: "rs0",
  members: [
    { _id: 0, host: "127.0.0.1:27017" },
    { _id: 1, host: "127.0.0.1:27018" },
    { _id: 2, host: "127.0.0.1:27019" }
  ]
})
EOF

echo "Waiting for primary election..."
sleep 8

mongo --quiet --port 27017 <<'EOF'
printjson(rs.status().members.map(m => ({name:m.name, stateStr:m.stateStr, health:m.health})))
EOF

echo "✅ Ubuntu MongoDB 3.2.5 replica set rs0 is configured."