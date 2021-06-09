#!/bin/bash

# Utility to stop and remove if existing
stop_remove_safe() {
  OLD="$(docker ps --all --quiet --filter=name="$1")"
  if [ -n "$OLD" ]; then
    echo "Removing existing container: $1 ..."
    docker stop "$OLD" && docker rm "$OLD"
  fi
}

echo "#0 Get core base's required images nginx-alpine and bitnami-couchdb"
# 1. [Decorated] For Angular Federated Modules, usually with Svelte/Plain TypeScript/Rescript
docker pull nginx:1.21-alpine
# 2. For UI component driven UIX-API, guaranteed to be the way the UI needs the API responses to be
docker pull bitnami/couchdb:3.1.1

echo "#1 Building and starting core base..."

NGX_FED_MODS="dnglx"
echo "#1.1. Containerize and start nginxngx dist server: $NGX_FED_MODS"
stop_remove_safe "$NGX_FED_MODS"
docker build -t nginxngx-image:v1 .
docker run -d --name "$NGX_FED_MODS" -p 80:80 nginxngx-image:v1

COUCH_ERL="couch-pot-ato"
echo "#1.2. Set up couch-pot-ato server: $COUCH_ERL"
stop_remove_safe "$COUCH_ERL"
docker run -d --name "$COUCH_ERL" \
  -p 5984:5984 \
  -e COUCHDB_PASSWORD=password \
  -v couchdb:/bitnami/couchdb \
  bitnami/couchdb:3.1.1

# COUCHDB_USER: The username of the administrator user when authentication is enabled. Default: admin
# COUCHDB_PASSWORD: The password to use for login with the admin user set in the COUCHDB_USER environment variable. Default: couchdb
# COUCHDB_NODENAME: A server alias for clusteecho "ing support. Default: couchdb@127.0.0.1"
# COUCHDB_PORT_NUMBER: Standard port for all HTTP API requests. Default: 5984
# COUCHDB_CLUSTER_PORT_NUMBER: Port for cluster communication. Default: 9100
# COUCHDB_BIND_ADDRESS: Address binding for the standard port. Default: 0.0.0.0

echo "#2. Get opt core's required images timescaledb-postgis, bitnami-keycloak and bitnami-nginx"

# Get opt-core base
# 3. [Linked 0] For Relational, Time series and GIS datasets
docker pull timescale/timescaledb-postgis:latest-pg12
# 4. [Linked 0] For OIDC/JWT and complex user roles, authorizations etc
docker pull bitnami/keycloak:13
# 5. [Decorated, Linked 0] Mini-deb for prox-e-g APIs (Ledgers, Dashboards, MACERs)
docker pull bitnami/nginx:1.19

echo "#3 Building and starting opt core..."

echo "#3.1 Set up postgre-space-time"

KEY_NET="key-net"

PG_SPACE_TIME="pg-space-time"
docker network create "$KEY_NET" || true
stop_remove_safe "$PG_SPACE_TIME"
docker run -d --name "$PG_SPACE_TIME" \
  -p 5432:5432 \
  --net "$KEY_NET" \
  -e POSTGRES_USER=pgst \
  -e POSTGRES_DB=pgst \
  -e POSTGRES_PASSWORD=password \
  -e NO_TS_TUNE=true \
  -e TIMESCALEDB_TELEMETRY=off \
  -e PGDATA=/var/lib/postgresql/data/pgdata \
  -v pgdata:/var/lib/postgresql/data \
  timescale/timescaledb-postgis:latest-pg12

KEY_POT="key-pot"
echo "#3.2 Set up $KEY_POT with $PG_SPACE_TIME"
stop_remove_safe "$KEY_POT"
docker run -d --name "$KEY_POT" \
  --net "$KEY_NET" \
  -p 8080:8080 \
  -e KEYCLOAK_DATABASE_HOST="$PG_SPACE_TIME" \
  -e KEYCLOAK_DATABASE_NAME=pgst \
  -e KEYCLOAK_DATABASE_USER=pgst \
  -e KEYCLOAK_DATABASE_PASSWORD=password \
  bitnami/keycloak:13
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

