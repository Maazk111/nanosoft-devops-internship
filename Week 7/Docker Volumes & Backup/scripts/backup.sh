#!/usr/bin/env bash
set -euo pipefail
source /home/vagrant/week7-volumes/scripts/utils.sh

DB_CONTAINER="pgdb"
DB_NAME="week7db"
DB_USER="week7user"
DB_PASS="week7pass"

REMOTE_HOST="192.168.56.91"
REMOTE_USER="vagrant"
REMOTE_DIR="/opt/remote-backups"

STAMP="$(ts)"
DUMP_FILE="$BACKUPS_DIR/${DB_NAME}_${STAMP}.sql"
ARCHIVE_FILE="$BACKUPS_DIR/${DB_NAME}_${STAMP}.tar.gz"

log "Backup: Create SQL dump from Postgres"
run_and_log "01_backup_dump.txt" "sudo docker exec -e PGPASSWORD=$DB_PASS $DB_CONTAINER pg_dump -U $DB_USER -d $DB_NAME > $DUMP_FILE"
run_and_log "01_backup_dump.txt" "ls -lah $DUMP_FILE"

log "Backup: Compress the dump"
run_and_log "02_backup_compress.txt" "tar -czf $ARCHIVE_FILE -C $BACKUPS_DIR $(basename $DUMP_FILE)"
run_and_log "02_backup_compress.txt" "ls -lah $ARCHIVE_FILE"

log "Backup: Upload to remote server (scp) - run as vagrant user"
run_and_log "03_backup_upload.txt" "sudo -u vagrant scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null $ARCHIVE_FILE ${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_DIR}/"
run_and_log "03_backup_upload.txt" "sudo -u vagrant ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ${REMOTE_USER}@${REMOTE_HOST} 'ls -lah ${REMOTE_DIR} | tail -n +1'"

echo "ARCHIVE_FILE=$ARCHIVE_FILE" > "$RESULTS_DIR/backup_uploaded.txt"
echo -e "\n✅ Backup complete: $ARCHIVE_FILE\n"