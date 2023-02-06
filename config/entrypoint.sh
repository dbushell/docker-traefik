#!/bin/sh

TRFK_DIR="/etc/traefik"
TRFK_TEMPLATE="$TRFK_DIR/template.toml"
TRFK_CONFIG="$TRFK_DIR/traefik.toml"
TRFK_CONFIG_NOTICE="#\n# Warning!\n# This file is auto-generated and will be overwritten!\n#\n\n"

echo "Generating Traefik config: $TRFK_CONFIG"

{
  apk add gettext
  envsubst < $TRFK_TEMPLATE > $TRFK_CONFIG
  echo -e "$TRFK_CONFIG_NOTICE$(cat $TRFK_CONFIG)" > $TRFK_CONFIG
} &> /dev/null

exec traefik
