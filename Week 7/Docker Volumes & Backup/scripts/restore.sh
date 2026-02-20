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

LATEST_REMOTE_ARCHIVE="$(sudo -u vagrant ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ${REMOTE_USER}@${REMOTE_HOST} "ls -1t ${REMOTE_DIR}/*.tar.gz 2>/dev/null | head -n 1" || true)"
if [[ -z "$LATEST_REMOTE_ARCHIVE" ]]; then
  echo "No remote archive found in ${REMOTE_DIR} on backup-server." >&2
  exit 1
fi

log "Restore: Pull latest backup archive from remote"
LOCAL_ARCHIVE="$BACKUPS_DIR/restore_$(basename "$LATEST_REMOTE_ARCHIVE")"

run_and_log "04_restore_pull.txt" "sudo -u vagrant ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ${REMOTE_USER}@${REMOTE_HOST} 'ls -lah ${LATEST_REMOTE_ARCHIVE}'"
run_and_log "04_restore_pull.txt" "sudo -u vagrant scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ${REMOTE_USER}@${REMOTE_HOST}:${LATEST_REMOTE_ARCHIVE} ${LOCAL_ARCHIVE}"
run_and_log "04_restore_pull.txt" "ls -lah ${LOCAL_ARCHIVE}"

log "Restore: Extract SQL dump"
run_and_log "05_restore_extract.txt" "tar -xzf ${LOCAL_ARCHIVE} -C ${BACKUPS_DIR}"
SQL_FILE="$(tar -tzf "$LOCAL_ARCHIVE" | head -n 1)"
run_and_log "05_restore_extract.txt" "ls -lah ${BACKUPS_DIR}/${SQL_FILE}"

log "Restore: Recreate container with FRESH volume"
run_and_log "06_restore_recreate.txt" "sudo docker rm -f ${DB_CONTAINER} >/dev/null 2>&1 || true"
run_and_log "06_restore_recreate.txt" "sudo docker volume rm pgdata_week7 >/dev/null 2>&1 || true"
run_and_log "06_restore_recreate.txt" "sudo docker volume create pgdata_week7"

run_and_log "06_restore_recreate.txt" "sudo docker run -d --name ${DB_CONTAINER} \
  -e POSTGRES_DB=${DB_NAME} -e POSTGRES_USER=${DB_USER} -e POSTGRES_PASSWORD=${DB_PASS} \
  -v pgdata_week7:/var/lib/postgresql/data \
  -p 5432:5432 postgres:16-alpine"

run_and_log "06_restore_recreate.txt" "sleep 5"
run_and_log "06_restore_recreate.txt" "sudo docker exec ${DB_CONTAINER} pg_isready -U ${DB_USER} -d ${DB_NAME}"

log "Restore: Import SQL into database"
run_and_log "07_restore_import.txt" "cat ${BACKUPS_DIR}/${SQL_FILE} | sudo docker exec -i -e PGPASSWORD=${DB_PASS} ${DB_CONTAINER} psql -U ${DB_USER} -d ${DB_NAME}"

log "Verify: Data exists after restore"
run_and_log "08_restore_verify.txt" "sudo docker exec -e PGPASSWORD=${DB_PASS} ${DB_CONTAINER} psql -U ${DB_USER} -d ${DB_NAME} -c 'SELECT * FROM students ORDER BY id;'"

echo -e "\n✅ Restore completed and verified.\n"