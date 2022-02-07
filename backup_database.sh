#!/usr/bin/env sh

# PostgreSQL database dump for regular backups

# SQL Dump
# https://www.postgresql.org/docs/12/backup-dump.html

# Restoring the Dump
# https://www.postgresql.org/docs/12/backup-dump.html#BACKUP-DUMP-RESTORE

# Options
# Target file path
file=/mnt/data/pg_dump/thingsboard.sql
# Connection options
host=localhost
user=thingsboard
dbname=thingsboard

# Exit immediately if a command exits with a non-zero status.
set -e

# The connection options are loaded from ~/.pgpass
# https://www.postgresql.org/docs/12/libpq-pgpass.html
pg_dump --no-password --file=$file
