#!/usr/bin/env bash
set -euo pipefail

RESULTS_DIR="/home/vagrant/week7-volumes/results"
BACKUPS_DIR="/home/vagrant/week7-volumes/backups"
ASSETS_DIR="/home/vagrant/week7-volumes/assets"

mkdir -p "$RESULTS_DIR" "$BACKUPS_DIR"

ts() { date +"%Y-%m-%d_%H-%M-%S"; }

log() { echo -e "\n===== $1 =====\n"; }

# run_and_log "file.txt" "command..."
run_and_log() {
  local file="$1"; shift
  local cmd="$*"
  local out="$RESULTS_DIR/$file"
  echo "+ $cmd" | tee -a "$out"
  eval "$cmd" 2>&1 | tee -a "$out"
}
