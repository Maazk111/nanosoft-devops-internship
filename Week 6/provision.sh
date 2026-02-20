#!/usr/bin/env bash
set -euo pipefail

# =========================
# Config
# =========================
TOOPLATE_URL="https://www.tooplate.com/zip-templates/2144_parallax_depth.zip"
APP_DIR="/var/www/html/site"
SERVICE_NAME="simple-site-3000"

echo "==> Updating system..."
apt-get update -y

echo "==> Installing dependencies..."
apt-get install -y wget unzip python3 nginx

# =========================
# Deploy website
# =========================
echo "==> Creating app directory..."
rm -rf "$APP_DIR"
mkdir -p "$APP_DIR"

cd /tmp
rm -rf tooplate_build
mkdir tooplate_build
cd tooplate_build

echo "==> Downloading Tooplate template..."
wget -O template.zip "$TOOPLATE_URL"

echo "==> Extracting template..."
unzip -o template.zip -d extracted

TEMPLATE_ROOT=$(find extracted -mindepth 1 -maxdepth 1 -type d | head -n 1)

if [ -z "$TEMPLATE_ROOT" ]; then
  echo "❌ Template folder not found"
  exit 1
fi

echo "==> Copying files to $APP_DIR"
cp -r "$TEMPLATE_ROOT"/* "$APP_DIR"/

chown -R www-data:www-data "$APP_DIR"
chmod -R 755 "$APP_DIR"

# =========================
# Python server systemd
# =========================
echo "==> Creating Python server systemd service..."

cat <<EOF > /etc/systemd/system/${SERVICE_NAME}.service
[Unit]
Description=Static Website on Port 3000
After=network.target

[Service]
Type=simple
WorkingDirectory=${APP_DIR}
ExecStart=/usr/bin/python3 -m http.server 3000 --bind 127.0.0.1
Restart=always
User=www-data
Group=www-data

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now ${SERVICE_NAME}

# =========================
# Nginx Reverse Proxy
# =========================
echo "==> Configuring Nginx reverse proxy..."

rm -f /etc/nginx/sites-enabled/default

cat <<EOF > /etc/nginx/sites-available/reverse-proxy
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://127.0.0.1:3000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    }
}
EOF

ln -s /etc/nginx/sites-available/reverse-proxy /etc/nginx/sites-enabled/

nginx -t
systemctl restart nginx
systemctl enable nginx

echo "==> Reverse Proxy setup complete!"

echo "======================================"
echo "✅ Deployment Finished"
echo "Access your site at:"
echo "👉 http://localhost"
echo "👉 http://192.168.56.30"
echo "======================================"