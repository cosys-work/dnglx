#!/usr/bin/env bash

source env-utils.sh
# To enable pulling images before running use one of the two
# bash env-utils.sh pull-aot
# pull_aot

echo "#1 Building and starting core base..."

NGX_FED_MODS="dnglx"
echo "#1.1. Containerize and start nginxngx dist server: $NGX_FED_MODS"
safe_stop_remove "$NGX_FED_MODS"
docker build -f Ngingx.Dockerfile .
docker run -d --name "$NGX_FED_MODS" -p "$DNGLX_PORT":80 nginxngx-image:"$DNGLX_VRSN"
echo "#A The $NGX_FED_MODS container has been built and started."

COUCH_ERL="couch-pot-ato"
echo "#1.2. Set up couch-pot-ato server: $COUCH_ERL"
safe_stop_remove "$COUCH_ERL"
docker run -d --name "$COUCH_ERL" \
  -p "$COUCHDB_PORT":5984 \
  -e COUCHDB_PASSWORD=password \
  -v couchdb:/bitnami/couchdb \
  bitnami/couchdb:"$COUCHDB_VRSN"
echo "#B The $COUCH_ERL container has been started."
# COUCHDB_USER: The username of the administrator user when authentication is enabled. Default: admin
# COUCHDB_PASSWORD: The password to use for login with the admin user set in the COUCHDB_USER environment variable. Default: couchdb
# COUCHDB_NODENAME: A server alias for clustering support. Default: couchdb@127.0.0.1"
# COUCHDB_PORT_NUMBER: Standard port for all HTTP API requests. Default: 5984
# COUCHDB_CLUSTER_PORT_NUMBER: Port for cluster communication. Default: 9100
# COUCHDB_BIND_ADDRESS: Address binding for the standard port. Default: 0.0.0.0

echo "#2. Get opt core's required images timescaledb-postgis, bitnami-keycloak and bitnami-nginx"

echo "#3 Building and starting opt core..."

echo "#3.1 Set up postgre-space-time"

export KEY_NET="key-net"

export PG_SPACE_TIME="pg-space-time"
docker network create "$KEY_NET" 2> /dev/null
safe_stop_remove "$PG_SPACE_TIME"
docker run -d --name "$PG_SPACE_TIME" \
  -p "$POSTGRES_PORT":5432 \
  --net "$KEY_NET" \
  -e POSTGRES_USER=pgst \
  -e POSTGRES_DB=pgst \
  -e POSTGRES_PASSWORD=password \
  -e NO_TS_TUNE=true \
  -e TIMESCALEDB_TELEMETRY=off \
  -e PGDATA=/var/lib/postgresql/data/pgdata \
  -v pgdata:/var/lib/postgresql/data \
  timescale/timescaledb-postgis:"$TIMESCALE_POSTGIS_VRSN"
echo "#C The $PG_SPACE_TIME container has been started."

ROCKS="rocks"
echo "#3.2 Set up $ROCKS"
safe_stop_remove "$ROCKS"
docker run --name "$ROCKS" -d -v "$(pwd)/db/:/typedb-all-linux/server/db/" -p "$ROCKS_PORT":1729 vaticle/typedb:"$ROCKS_VRSN"

KEY_POT="key-pot"
echo "#3.3 Set up $KEY_POT with $PG_SPACE_TIME"
safe_stop_remove "$KEY_POT"
docker run -d --name "$KEY_POT" \
  --net "$KEY_NET" \
  -p "$KEYCLOAK_PORT":8080 \
  -e KEYCLOAK_DATABASE_HOST="$PG_SPACE_TIME" \
  -e KEYCLOAK_DATABASE_NAME=pgst \
  -e KEYCLOAK_DATABASE_USER=pgst \
  -e KEYCLOAK_DATABASE_PASSWORD=password \
  bitnami/keycloak:"$KEYCLOAK_VRSN"
echo "#D The $KEY_POT container has been started."
#  -e JDBC_PARAMS="connectTimeout=30000" \

# Creates administrator and manager user on boot.
# KEYCLOAK_CREATE_ADMIN_USER: Create administrator user on boot. Default: true.
# ADMIN_USER: Administrator default user. Default: user.
# ADMIN_PASSWORD: Administrator default password. Default: bitnami.
# MANAGEMENT_USER: WildFly default management user. Default: manager.
# MANAGEMENT_PASSWORD: WildFly default management password. Default: bitnami1.

# PGSQL Config
#  -e KEYCLOAK_DATABASE_HOST=postgresql \
#  -e KEYCLOAK_DATABASE_PORT=5432 \
# KEYCLOAK_DATABASE_SCHEMA: PostgreSQL database schema. Default: public.

# Keycloak UI Config
# KEYCLOAK_HTTP_PORT: Keycloak HTTP port. Default: 8080.
# KEYCLOAK_HTTPS_PORT: Keycloak HTTPS port. Default: 8443.
# KEYCLOAK_BIND_ADDRESS: Keycloak bind address. Default: 0.0.0.0.

# 5. Configure proxe-g middleware with keycloak, couch and postgrest calls

