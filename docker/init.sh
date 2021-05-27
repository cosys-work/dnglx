#!/bin/bash
# Get core base
docker pull nginx:1.21-alpine
docker pull bitnami/couchdb:3.1.1

# Get opt-core base
docker pull timescale/timescaledb-postgis:latest-pg12
docker pull bitnami/keycloak:13
# docker pull postgrest/postgrest:v7.0.1
docker pull bitnami/nginx:1.19

echo "Starting and building..."

echo "# 1. Containerize and start dist server"
docker stop dnglx 2> /dev/null
docker rm -f dnglx 2> /dev/null
docker build -t nginxngx-image:v1 .
docker run -d --name dnglx -p 80:80 nginxngx-image:v1

echo "# 2. Set up couch-pot-ato"
docker stop couch-pot-ato 2> /dev/null
docker rm -f couch-pot-ato 2> /dev/null
docker run -d --name couch-pot-ato \
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

echo "# 3. Set up postgre-space-time"
docker network create keycloak-network 2> /dev/null
docker stop pg-space-time 2> /dev/null
docker rm -f pg-space-time 2> /dev/null
docker run -d --name pg-space-time \
  -p 5432:5432 \
  --net keycloak-network \
  -e POSTGRES_USER=pgst \
  -e POSTGRES_DB=pgst \
  -e POSTGRES_PASSWORD=password \
  -e NO_TS_TUNE=true \
  -e TIMESCALEDB_TELEMETRY=off \
  -e PGDATA=/var/lib/postgresql/data/pgdata \
  -v pgdata:/var/lib/postgresql/data \
  timescale/timescaledb-postgis:latest-pg12

echo "# 4. Set up keycloak"
docker stop keycloak-pot 2> /dev/null
docker rm -f keycloak-pot 2> /dev/null
docker run -d --name keycloak-pot \
  --net keycloak-network \
  -p 8080:8080 \
  -e KEYCLOAK_DATABASE_HOST=pg-space-time \
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

