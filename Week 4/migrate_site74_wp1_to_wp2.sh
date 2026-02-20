#!/bin/bash
set -e

echo "== Migration: wp1 -> wp2 (site74) =="

echo "-> Exporting DB from wp1"
vagrant ssh wp1 -c "sudo mysqldump wp_site74 > /tmp/wp_site74.sql"

echo "-> Copying dump to host"
vagrant scp wp1:/tmp/wp_site74.sql ./wp_site74.sql

echo "-> Uploading dump to wp2"
vagrant upload ./wp_site74.sql /tmp/wp_site74.sql wp2

echo "-> Verifying dump exists on wp2"
vagrant ssh wp2 -c "ls -lah /tmp/wp_site74.sql"

echo "-> Importing DB on wp2"
vagrant ssh wp2 -c "sudo mysql wp_site74 < /tmp/wp_site74.sql"

echo "✅ Migration completed successfully"