#!/bin/sh

set -eu

# we assume here that all secrets are already read to environment variables

# if JORE4_DB_URL was not set, build it from parts
if [ -z "${JORE4_DB_URL+x}" ]; then
  export JORE4_DB_PORT=${JORE4_DB_PORT:-"5432"}
  export JORE4_DB_URL="jdbc:postgresql://${JORE4_DB_HOSTNAME}:${JORE4_DB_PORT}/${JORE4_DB_DATABASE}?stringtype=unspecified"
fi
