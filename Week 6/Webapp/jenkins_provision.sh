#!/usr/bin/env bash
set -euo pipefail

apt-get update -y
apt-get install -y ca-certificates curl gnupg git unzip nginx fontconfig openjdk-17-jre

# Jenkins repo + install
mkdir -p /usr/share/keyrings
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key \
  | tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" \
  | tee /etc/apt/sources.list.d/jenkins.list > /dev/null

apt-get update -y
apt-get install -y jenkins
systemctl enable --now jenkins

# Versioned deploy dirs
mkdir -p /var/www/html/releases
ln -sfn /var/www/html/releases /var/www/html/current || true
mkdir -p /var/www/html/current

# Nginx serve on 3000
rm -f /etc/nginx/sites-enabled/default
cat > /etc/nginx/sites-available/site3000 <<'EOF'
server {
    listen 3000;
    server_name _;
    root /var/www/html/current;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }
}
EOF
ln -sf /etc/nginx/sites-available/site3000 /etc/nginx/sites-enabled/site3000
nginx -t
systemctl enable --now nginx
systemctl reload nginx

# Allow Jenkins to run required commands
cat > /etc/sudoers.d/jenkins-deploy <<'EOF'
jenkins ALL=(root) NOPASSWD: /bin/mkdir, /bin/rm, /bin/ln, /bin/cp, /bin/chown, /usr/sbin/nginx, /bin/systemctl
EOF
chmod 440 /etc/sudoers.d/jenkins-deploy

echo "============================================"
echo "Jenkins:  http://localhost:8080"
echo "Website:  http://localhost:3000"
echo "Initial Jenkins Password:"
cat /var/lib/jenkins/secrets/initialAdminPassword || true
echo "============================================"