#!/usr/bin/env bash
set -euo pipefail
source /home/vagrant/week7-volumes/scripts/utils.sh

DB_CONTAINER="pgdb"
DB_NAME="week7db"
DB_USER="week7user"
DB_PASS="week7pass"

log "STEP 0: Prep results dir"
run_and_log "00_info.txt" "whoami"
run_and_log "00_info.txt" "hostname -I"
run_and_log "00_info.txt" "sudo docker --version"
run_and_log "00_info.txt" "sudo docker info | head -n 30 || true"

log "STEP 1: Cleanup old run"
bash /home/vagrant/week7-volumes/scripts/cleanup.sh

log "STEP 2: Create named volume for database"
run_and_log "01_volume.txt" "sudo docker volume create pgdata_week7"
run_and_log "01_volume.txt" "sudo docker volume ls | grep pgdata_week7 || true"

log "STEP 3: Start Postgres using named volume"
run_and_log "02_db_start.txt" "sudo docker run -d --name ${DB_CONTAINER} \
  -e POSTGRES_DB=${DB_NAME} -e POSTGRES_USER=${DB_USER} -e POSTGRES_PASSWORD=${DB_PASS} \
  -v pgdata_week7:/var/lib/postgresql/data \
  -p 5432:5432 postgres:16-alpine"

run_and_log "02_db_start.txt" "sleep 5"
run_and_log "02_db_start.txt" "sudo docker exec ${DB_CONTAINER} pg_isready -U ${DB_USER} -d ${DB_NAME}"
run_and_log "02_db_start.txt" "sudo docker ps --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}'"

log "STEP 4: Seed database with sample data"
run_and_log "03_seed.txt" "sudo docker exec -e PGPASSWORD=${DB_PASS} -i ${DB_CONTAINER} psql -U ${DB_USER} -d ${DB_NAME} < ${ASSETS_DIR}/sample.sql"
run_and_log "03_seed.txt" "sudo docker exec -e PGPASSWORD=${DB_PASS} ${DB_CONTAINER} psql -U ${DB_USER} -d ${DB_NAME} -c 'SELECT * FROM students ORDER BY id;'"

log "STEP 5: Backup (dump -> compress -> upload to remote)"
bash /home/vagrant/week7-volumes/scripts/backup.sh

log "STEP 6: Restore from remote backup (fresh volume) and verify"
bash /home/vagrant/week7-volumes/scripts/restore.sh

log "STEP 7: Final proof list"
run_and_log "99_final.txt" "sudo docker volume ls | sed -n '1,20p'"
run_and_log "99_final.txt" "ls -lah $RESULTS_DIR"
run_and_log "99_final.txt" "ls -lah $BACKUPS_DIR"

cat > "$RESULTS_DIR/SUMMARY.txt" <<EOF
Week7 - Docker Volumes & Backup (Automated)

Created named volume: pgdata_week7
Started Postgres container: pgdb
Seeded DB using assets/sample.sql (students table + rows)
Backed up using pg_dump -> compressed tar.gz
Uploaded backup to remote server (backup-server)
Restored DB from remote backup into fresh volume and verified data

Proof logs in:
  $RESULTS_DIR

EOF

echo -e "\n✅ DONE. Check results in: $RESULTS_DIR\n"
