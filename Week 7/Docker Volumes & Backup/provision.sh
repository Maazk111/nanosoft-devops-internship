#!/usr/bin/env bash
set -euo pipefail

ROLE="${1:-db}"
log() { echo -e "\n[PROVISION][$ROLE] $*\n"; }

if [[ "$ROLE" == "db" ]]; then
  log "Updating apt + installing tools..."
  apt-get update -y
  apt-get install -y ca-certificates curl gnupg lsb-release jq tar gzip rsync openssh-client

  log "Installing Docker (non-interactive GPG)..."
  install -m 0755 -d /etc/apt/keyrings

  curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
    | gpg --dearmor --batch --yes --no-tty \
    -o /etc/apt/keyrings/docker.gpg

  chmod a+r /etc/apt/keyrings/docker.gpg

  echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
  > /etc/apt/sources.list.d/docker.list

  apt-get update -y
  apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  systemctl enable --now docker
  usermod -aG docker vagrant || true

  log "Prepare lab directories..."
  mkdir -p /home/vagrant/week7-volumes/{results,backups,scripts,assets}
  chown -R vagrant:vagrant /home/vagrant/week7-volumes

  log "Copy project from /vagrant into /home/vagrant/week7-volumes..."
  rsync -a /vagrant/scripts/ /home/vagrant/week7-volumes/scripts/
  rsync -a /vagrant/assets/  /home/vagrant/week7-volumes/assets/
  rsync -a /vagrant/results/ /home/vagrant/week7-volumes/results/
  chmod +x /home/vagrant/week7-volumes/scripts/*.sh
  chown -R vagrant:vagrant /home/vagrant/week7-volumes

  log "Generate SSH key for vagrant (for upload/restore to backup-server)..."
  sudo -u vagrant mkdir -p /home/vagrant/.ssh
  if [[ ! -f /home/vagrant/.ssh/id_ed25519 ]]; then
    sudo -u vagrant ssh-keygen -t ed25519 -N "" -f /home/vagrant/.ssh/id_ed25519 >/dev/null
  fi
  chmod 700 /home/vagrant/.ssh
  chmod 600 /home/vagrant/.ssh/id_ed25519
  chmod 644 /home/vagrant/.ssh/id_ed25519.pub

  log "Drop public key into shared folder so backup-server can install it..."
  mkdir -p /vagrant/remote
  cp -f /home/vagrant/.ssh/id_ed25519.pub /vagrant/remote/db_vagrant_id_ed25519.pub

  log "Done (docker-db)."

elif [[ "$ROLE" == "backup" ]]; then
  log "Updating apt + installing openssh-server..."
  apt-get update -y
  apt-get install -y openssh-server rsync tar gzip

  systemctl enable --now ssh

  log "Create remote backup directory..."
  mkdir -p /opt/remote-backups
  chmod 777 /opt/remote-backups

  log "Ensure vagrant user has SSH enabled..."
  mkdir -p /home/vagrant/.ssh
  touch /home/vagrant/.ssh/authorized_keys
  chmod 700 /home/vagrant/.ssh
  chmod 600 /home/vagrant/.ssh/authorized_keys
  chown -R vagrant:vagrant /home/vagrant/.ssh

  log "Install db VM SSH public key for passwordless SSH..."
  if [[ -f /vagrant/remote/db_vagrant_id_ed25519.pub ]]; then
    cat /vagrant/remote/db_vagrant_id_ed25519.pub >> /home/vagrant/.ssh/authorized_keys
    sort -u /home/vagrant/.ssh/authorized_keys -o /home/vagrant/.ssh/authorized_keys
    chown vagrant:vagrant /home/vagrant/.ssh/authorized_keys
    chmod 600 /home/vagrant/.ssh/authorized_keys
    log "Key installed successfully."
  else
    log "Public key NOT found yet. Run: vagrant provision docker-db then vagrant provision backup-server"
  fi

  log "Done (backup-server)."
else
  echo "Unknown ROLE: $ROLE" >&2
  exit 1
fi