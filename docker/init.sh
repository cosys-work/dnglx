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

# 1. Containerize and start dist server
docker build -t html-nginxngx-image:v1 .
docker run -d -p 80:80 html-nginxngx-image:v1

# 2. Set up couch-pot-ato
docker run -d --name couch-pot-ato \
  -p 5984:5984 \
  -e COUCHDB_PASSWORD=password \
  -v couchdb:/bitnami/couchdb \
  bitnami/couchdb:3.1.1

# COUCHDB_USER: The username of the administrator user when authentication is enabled. Default: admin
# COUCHDB_PASSWORD: The password to use for login with the admin user set in the COUCHDB_USER environment variable. Default: couchdb
# COUCHDB_NODENAME: A server alias for clustering support. Default: couchdb@127.0.0.1
# COUCHDB_PORT_NUMBER: Standard port for all HTTP API requests. Default: 5984
# COUCHDB_CLUSTER_PORT_NUMBER: Port for cluster communication. Default: 9100
# COUCHDB_BIND_ADDRESS: Address binding for the standard port. Default: 0.0.0.0

# 3. Set up postgre-space-time
docker run -d --name pg-space-time \
  -p 5532:5432 \
  -e POSTGRES_DB=pgst \
  -e POSTGRES_USER=pgst \
  -e POSTGRES_PASSWORD=password \
  -e NO_TS_TUNE=true \
  -e TIMESCALEDB_TELEMETRY=off \
  timescale/timescaledb:latest-pg12

# 4. Set up keycloak
docker run -d --name keycloak-pot \
  -p 8180:8080 \
  -e KEYCLOAK_DATABASE_HOST=localhost \
  -e KEYCLOAK_DATABASE_NAME=pgst \
  -e KEYCLOAK_DATABASE_USER=pgst \
  -e KEYCLOAK_DATABASE_PASSWORD=pgstpass \
  bitnami/keycloak:13

# Creates administrator and manager user on boot.
# ADMIN_USER: Administrator default user. Default: user.
# ADMIN_PASSWORD: Administrator default password. Default: bitnami.
# MANAGEMENT_USER: WildFly default management user. Default: manager.
# MANAGEMENT_PASSWORD: WildFly default management password. Default: bitnami1.

# PGSQL Config
# KEYCLOAK_DATABASE_PORT: PostgreSQL port. Default: 5432.
# KEYCLOAK_DATABASE_SCHEMA: PostgreSQL database schema. Default: public.

# Keycloak UI Config
# KEYCLOAK_HTTP_PORT: Keycloak HTTP port. Default: 8080.
# KEYCLOAK_HTTPS_PORT: Keycloak HTTPS port. Default: 8443.
# KEYCLOAK_BIND_ADDRESS: Keycloak bind address. Default: 0.0.0.0.

# 5. Configure proxe-g middleware with keycloak, couch and postgrest calls

