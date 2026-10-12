#!/usr/bin/env bash
# Génère un certificat auto-signé pour Nginx (la clé reste sur la machine)
set -euo pipefail

SSL_DIR="$(dirname "$0")/ssl"
DOMAIN="${1:-vault.lab.internal}"
mkdir -p "$SSL_DIR"

openssl req -x509 -newkey rsa:2048 -sha256 -days 365 -nodes \
  -keyout "$SSL_DIR/nginx.key" -out "$SSL_DIR/nginx.crt" \
  -subj "/CN=$DOMAIN" \
  -addext "subjectAltName=DNS:$DOMAIN,DNS:localhost"

chmod 600 "$SSL_DIR/nginx.key"
echo "Certificat créé pour $DOMAIN dans $SSL_DIR"
