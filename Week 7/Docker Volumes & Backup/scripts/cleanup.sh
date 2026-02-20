#!/usr/bin/env bash
set -euo pipefail
source /home/vagrant/week7-volumes/scripts/utils.sh

run_and_log "00_cleanup.txt" "sudo docker rm -f pgdb >/dev/null 2>&1 || true"
run_and_log "00_cleanup.txt" "sudo docker volume rm pgdata_week7 >/dev/null 2>&1 || true"

# Remove old backup artifacts (local)
run_and_log "00_cleanup.txt" "rm -f $BACKUPS_DIR/* || true"
run_and_log "00_cleanup.txt" "rm -f $RESULTS_DIR/backup_uploaded.txt $RESULTS_DIR/restore_verify.txt $RESULTS_DIR/*.sql 2>/dev/null || true"

echo -e "\n✅ Cleanup done.\n"
