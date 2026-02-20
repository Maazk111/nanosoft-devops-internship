#!/usr/bin/env bash
set -euo pipefail

REDIS_VER="3.2.13"
REDIS_PASS="redis@123"

TARBALL="redis-${REDIS_VER}.tar.gz"
URL="https://download.redis.io/releases/${TARBALL}"

echo "[1/7] Installing dependencies..."
sudo apt-get update -y
sudo apt-get install -y build-essential tcl wget ca-certificates tar

echo "[2/7] Downloading Redis ${REDIS_VER}..."
cd /tmp
rm -f "${TARBALL}"

wget -q --show-progress "$URL"

if [ ! -s "${TARBALL}" ]; then
  echo "ERROR: Redis tarball download failed."
  exit 1
fi

echo "[3/7] Extracting Redis..."
tar xzf "${TARBALL}"
cd "redis-${REDIS_VER}"

echo "[4/7] Building Redis..."
make -j"$(nproc)"

echo "[5/7] Installing Redis..."
sudo make install

echo "[6/7] Configuring Redis..."
sudo mkdir -p /etc/redis /var/lib/redis
sudo cp redis.conf /etc/redis/redis.conf

sudo sed -i "s/^supervised no/supervised systemd/" /etc/redis/redis.conf
sudo sed -i "s|^dir .*|dir /var/lib/redis|" /etc/redis/redis.conf
sudo sed -i "s/^bind 127.0.0.1/bind 0.0.0.0/" /etc/redis/redis.conf

# Enable authentication
sudo sed -i "s/^# requirepass .*/requirepass ${REDIS_PASS}/" /etc/redis/redis.conf

echo "[7/7] Creating systemd service..."
sudo tee /etc/systemd/system/redis.service >/dev/null <<EOF
[Unit]
Description=Redis In-Memory Data Store
After=network.target

[Service]
ExecStart=/usr/local/bin/redis-server /etc/redis/redis.conf
ExecStop=/usr/local/bin/redis-cli -a ${REDIS_PASS} shutdown
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable redis
sudo systemctl restart redis

echo "✅ Redis ${REDIS_VER} installed successfully."
echo "🔐 Password: ${REDIS_PASS}"