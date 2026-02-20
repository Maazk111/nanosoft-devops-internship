#!/usr/bin/env bash
set -euo pipefail
export DEBIAN_FRONTEND=noninteractive

VM_IP="192.168.56.11"
VM_NAME="wp2"

SITE74_HOST="site74.wp2.local"
SITE82_HOST="site82.wp2.local"

SITE74_ROOT="/var/www/site74/public"
SITE82_ROOT="/var/www/site82/public"

DB_USER="wpuser"
DB_PASS="wp_pass_12345"

DB74="wp_site74"
DB82="wp_site82"

DB_HOST="${VM_IP}"

ADMIN_USER="admin"
ADMIN_PASS="Admin@12345"
ADMIN_EMAIL="admin@example.com"

echo "=============================="
echo "== $VM_NAME Provision Start =="
echo "=============================="

apt-get update -y
apt-get install -y \
  ca-certificates curl gnupg lsb-release unzip \
  apache2 mysql-server \
  apt-transport-https software-properties-common

a2enmod proxy proxy_fcgi rewrite headers >/dev/null || true
systemctl enable --now apache2
systemctl enable --now mysql

if grep -q '^bind-address' /etc/mysql/mysql.conf.d/mysqld.cnf; then
  sed -i "s/^bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf
else
  echo "bind-address = 0.0.0.0" >> /etc/mysql/mysql.conf.d/mysqld.cnf
fi
systemctl restart mysql

for i in {1..30}; do
  mysqladmin ping -uroot --silent && break
  sleep 1
done

if ! command -v docker >/dev/null 2>&1; then
  install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  chmod a+r /etc/apt/keyrings/docker.gpg

  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" > /etc/apt/sources.list.d/docker.list

  apt-get update -y
  apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  systemctl enable --now docker
fi

mkdir -p "$SITE74_ROOT" "$SITE82_ROOT"
chown -R www-data:www-data /var/www/site74 /var/www/site82
chmod -R 755 /var/www/site74 /var/www/site82

cat >/root/Dockerfile.php74 <<'EOF'
FROM php:7.4-fpm
RUN apt-get update && apt-get install -y \
    libzip-dev libpng-dev libjpeg-dev libfreetype6-dev \
    libicu-dev libxml2-dev libonig-dev \
  && docker-php-ext-configure gd --with-freetype --with-jpeg \
  && docker-php-ext-install -j$(nproc) mysqli zip gd intl xml mbstring opcache \
  && rm -rf /var/lib/apt/lists/*
EOF

cat >/root/Dockerfile.php82 <<'EOF'
FROM php:8.2-fpm
RUN apt-get update && apt-get install -y \
    libzip-dev libpng-dev libjpeg-dev libfreetype6-dev \
    libicu-dev libxml2-dev libonig-dev \
  && docker-php-ext-configure gd --with-freetype --with-jpeg \
  && docker-php-ext-install -j$(nproc) mysqli zip gd intl xml mbstring opcache \
  && rm -rf /var/lib/apt/lists/*
EOF

docker build -t wp-php74-fpm:local -f /root/Dockerfile.php74 /root
docker build -t wp-php82-fpm:local -f /root/Dockerfile.php82 /root

docker rm -f php74-fpm php82-fpm >/dev/null 2>&1 || true

docker run -d --name php74-fpm -p 9074:9000 \
  -v "$SITE74_ROOT":/var/www/html/site74 \
  wp-php74-fpm:local

docker run -d --name php82-fpm -p 9082:9000 \
  -v "$SITE82_ROOT":/var/www/html/site82 \
  wp-php82-fpm:local

mysql -uroot <<SQL
CREATE DATABASE IF NOT EXISTS ${DB74} CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE IF NOT EXISTS ${DB82} CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASS}';

GRANT ALL PRIVILEGES ON ${DB74}.* TO '${DB_USER}'@'%';
GRANT ALL PRIVILEGES ON ${DB82}.* TO '${DB_USER}'@'%';
FLUSH PRIVILEGES;
SQL

cat >/etc/apache2/sites-available/site74.conf <<EOF
<VirtualHost *:80>
  ServerName ${SITE74_HOST}
  DocumentRoot ${SITE74_ROOT}
  DirectoryIndex index.php index.html

  <Directory ${SITE74_ROOT}>
    Options FollowSymLinks
    AllowOverride All
    Require all granted
  </Directory>

  ProxyPreserveHost On
  ProxyPassMatch "^/(.*\\.php(/.*)?)$" "fcgi://127.0.0.1:9074/var/www/html/site74/\$1"
</VirtualHost>
EOF

cat >/etc/apache2/sites-available/site82.conf <<EOF
<VirtualHost *:80>
  ServerName ${SITE82_HOST}
  DocumentRoot ${SITE82_ROOT}
  DirectoryIndex index.php index.html

  <Directory ${SITE82_ROOT}>
    Options FollowSymLinks
    AllowOverride All
    Require all granted
  </Directory>

  ProxyPreserveHost On
  ProxyPassMatch "^/(.*\\.php(/.*)?)$" "fcgi://127.0.0.1:9082/var/www/html/site82/\$1"
</VirtualHost>
EOF

a2dissite 000-default.conf >/dev/null 2>&1 || true
a2ensite site74.conf site82.conf >/dev/null || true
apachectl -t
systemctl reload apache2

mkdir -p /tmp/wp-cli-cache
chown -R www-data:www-data /tmp/wp-cli-cache

wp_install() {
  local DOCROOT="$1"
  local DBNAME="$2"
  local URL="$3"
  local TITLE="$4"

  if [ -f "${DOCROOT}/wp-config.php" ]; then
    echo "WordPress already installed in ${DOCROOT}, skipping ✅"
    return 0
  fi

  docker run --rm --user 33:33 \
    -e HOME=/tmp \
    -e WP_CLI_CACHE_DIR=/tmp/wp-cli-cache \
    -v /tmp/wp-cli-cache:/tmp/wp-cli-cache \
    -v "${DOCROOT}":/var/www/html \
    wordpress:cli \
    php -d memory_limit=512M /usr/local/bin/wp core download --allow-root

  docker run --rm --user 33:33 \
    -e HOME=/tmp \
    -e WP_CLI_CACHE_DIR=/tmp/wp-cli-cache \
    -v /tmp/wp-cli-cache:/tmp/wp-cli-cache \
    -v "${DOCROOT}":/var/www/html \
    wordpress:cli \
    php -d memory_limit=512M /usr/local/bin/wp config create \
      --dbname="${DBNAME}" --dbuser="${DB_USER}" --dbpass="${DB_PASS}" --dbhost="${DB_HOST}" \
      --skip-check --allow-root

  docker run --rm --user 33:33 \
    -e HOME=/tmp \
    -e WP_CLI_CACHE_DIR=/tmp/wp-cli-cache \
    -v /tmp/wp-cli-cache:/tmp/wp-cli-cache \
    -v "${DOCROOT}":/var/www/html \
    wordpress:cli \
    php -d memory_limit=512M /usr/local/bin/wp core install \
      --url="${URL}" --title="${TITLE}" \
      --admin_user="${ADMIN_USER}" --admin_password="${ADMIN_PASS}" --admin_email="${ADMIN_EMAIL}" \
      --skip-email --allow-root
}

wp_install "$SITE74_ROOT" "$DB74" "http://${SITE74_HOST}" "WP2 Site74 (PHP 7.4)"
wp_install "$SITE82_ROOT" "$DB82" "http://${SITE82_HOST}" "WP2 Site82 (PHP 8.2)"

echo "=============================="
echo "DONE: $VM_NAME ✅"
echo "${SITE74_HOST} -> PHP 7.4"
echo "${SITE82_HOST} -> PHP 8.2"
echo "Admin: ${ADMIN_USER} / ${ADMIN_PASS}"
echo "=============================="