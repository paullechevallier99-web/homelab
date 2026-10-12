#!/bin/bash

set -Eeuo pipefail

BACKUP_DIR="/backup/mysql"
RETENTION_DAYS="${BACKUP_RETENTION_DAYS:-7}"

mkdir -p "$BACKUP_DIR"

while true; do
    TIMESTAMP=$(date '+%Y-%m-%d_%H-%M-%S')
    BACKUP_FILE="${BACKUP_DIR}/${MYSQL_DATABASE}_${TIMESTAMP}.sql.gz"
    TEMP_FILE="${BACKUP_FILE}.tmp"

    echo "[$(date)] Début de la sauvegarde MySQL"

    if MYSQL_PWD="$MYSQL_PASSWORD" mysqldump \
        --host=db \
        --user="$MYSQL_USER" \
        --no-tablespaces \
        --single-transaction \
        --routines \
        --triggers \
        --events \
        --hex-blob \
        "$MYSQL_DATABASE" | gzip > "$TEMP_FILE"; then

        mv "$TEMP_FILE" "$BACKUP_FILE"

        echo "[$(date)] Sauvegarde terminée : $BACKUP_FILE"

        find "$BACKUP_DIR" \
            -type f \
            -name '*.sql.gz' \
            -mtime "+${RETENTION_DAYS}" \
            -delete

    else
        rm -f "$TEMP_FILE"
        echo "[$(date)] ERREUR : échec de la sauvegarde" >&2
    fi

    sleep 86400
done
