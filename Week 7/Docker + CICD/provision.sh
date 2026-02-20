#!/usr/bin/env bash
set -euo pipefail

ROLE="${1:-}"
SHARED="/vagrant"
RESULTS="${SHARED}/results"
mkdir -p "${RESULTS}"

log() { echo "==== [$ROLE] $* ===="; }

install_docker() {
  log "Installing Docker..."
  apt-get update -y
  apt-get install -y ca-certificates curl gnupg lsb-release
  install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  chmod a+r /etc/apt/keyrings/docker.gpg

  echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
  > /etc/apt/sources.list.d/docker.list

  apt-get update -y
  apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  systemctl enable --now docker
}

install_common_tools() {
  apt-get update -y
  apt-get install -y git curl jq openssh-client openssh-server
  systemctl enable --now ssh
}

install_jenkins() {
  log "Installing Jenkins..."
  apt-get update -y
  apt-get install -y fontconfig openjdk-17-jre
  curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | tee /usr/share/keyrings/jenkins-keyring.asc >/dev/null
  echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ \
    > /etc/apt/sources.list.d/jenkins.list
  apt-get update -y
  apt-get install -y jenkins
  systemctl enable --now jenkins

  # allow jenkins to run docker
  usermod -aG docker jenkins || true
  systemctl restart jenkins
}

jenkins_generate_key_and_export() {
  log "Generating Jenkins SSH key..."
  sudo -u jenkins mkdir -p /var/lib/jenkins/.ssh
  sudo -u jenkins chmod 700 /var/lib/jenkins/.ssh

  if [ ! -f /var/lib/jenkins/.ssh/id_ed25519 ]; then
    sudo -u jenkins ssh-keygen -t ed25519 -N "" -f /var/lib/jenkins/.ssh/id_ed25519
  fi

  sudo -u jenkins chmod 600 /var/lib/jenkins/.ssh/id_ed25519
  sudo -u jenkins chmod 644 /var/lib/jenkins/.ssh/id_ed25519.pub

  # Export public key into shared folder so deploy VM can trust it
  cp /var/lib/jenkins/.ssh/id_ed25519.pub "${RESULTS}/jenkins_id_ed25519.pub"
  chmod 644 "${RESULTS}/jenkins_id_ed25519.pub"
  log "Exported pubkey to ${RESULTS}/jenkins_id_ed25519.pub"

  # Pre-add deploy host key (avoid prompts)
  sudo -u jenkins bash -lc "ssh-keyscan -H 192.168.56.111 >> /var/lib/jenkins/.ssh/known_hosts 2>/dev/null || true"
  sudo -u jenkins chmod 644 /var/lib/jenkins/.ssh/known_hosts
}

deploy_wait_and_trust_jenkins_key() {
  log "Waiting for Jenkins pubkey in shared folder..."
  local keyfile="${RESULTS}/jenkins_id_ed25519.pub"

  # wait up to 180s
  for i in $(seq 1 180); do
    if [ -s "$keyfile" ]; then break; fi
    sleep 1
  done

  if [ ! -s "$keyfile" ]; then
    echo "ERROR: Jenkins pubkey not found at $keyfile"
    exit 1
  fi

  log "Adding Jenkins pubkey to /home/vagrant/.ssh/authorized_keys"
  mkdir -p /home/vagrant/.ssh
  touch /home/vagrant/.ssh/authorized_keys
  chmod 700 /home/vagrant/.ssh
  chmod 600 /home/vagrant/.ssh/authorized_keys
  chown -R vagrant:vagrant /home/vagrant/.ssh

  mkdir -p /opt/deploy
  chown -R vagrant:vagrant /opt/deploy
  chmod 755 /opt/deploy


  # avoid duplicates
  grep -qF "$(cat "$keyfile")" /home/vagrant/.ssh/authorized_keys || cat "$keyfile" >> /home/vagrant/.ssh/authorized_keys
  chown vagrant:vagrant /home/vagrant/.ssh/authorized_keys
  log "Deploy now trusts Jenkins key ✅"
}

case "$ROLE" in
  jenkins)
    install_common_tools
    install_docker
    install_jenkins
    jenkins_generate_key_and_export
    log "DONE"
    ;;
  deploy)
    install_common_tools
    install_docker
    # optional: tools needed by verify/health
    apt-get install -y curl
    deploy_wait_and_trust_jenkins_key
    log "DONE"
    ;;
  *)
    echo "Usage: $0 {jenkins|deploy}"
    exit 1
    ;;
esac