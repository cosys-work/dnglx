#!/usr/bin/env bash

#A
export DNGLX_PORT=80
export DNGLX_VRSN="v1"
export NGX_NGINX_VRSN="1.21-alpine"
export PROX_EG_NGINX_VRSN="1.19"

#B
export COUCHDB_PORT=5984
export COUCHDB_VRSN="3.1.1"

#C
export POSTGRES_PORT=5432
export TIMESCALE_POSTGIS_VRSN="latest-pg12"

#D
export KEYCLOAK_PORT=8080
export KEYCLOAK_VRSN="13"

#Dev A
export PORTAINER_PORT=9090
export PORTAINER_API_PORT=8000
export PORTAINER_VRSN="latest"

#Dev B
export SONARQUBE_PORT=9000
export SONARQUBE_API_PORT=9092
export SONARQUBE_VRSN="lts-community"

pull_aot() {
  echo "#0 Get core base's required images nginx-alpine and bitnami-couchdb"
  # 1. [Decorated] For Angular Federated Modules, usually with Svelte/Plain TypeScript/Rescript
  docker pull nginx:"$NGX_NGINX_VRSN"
  # 2. For UI component driven UIX-API, guaranteed to be the way the UI needs the API responses to be
  docker pull bitnami/couchdb:"$COUCHDB_VRSN"
  # Get opt-core base
  # 3. [Linked 0] For Relational, Time series and GIS datasets
  docker pull timescale/timescaledb-postgis:"$TIMESCALE_POSTGIS_VRSN"
  # 4. [Linked 0] For OIDC/JWT and complex user roles, authorizations etc
  docker pull bitnami/keycloak:"$KEYCLOAK_VRSN"
  # 5. [Decorated, Linked 0] Mini-deb for prox-e-g APIs (Ledgers, Dashboards, MACERs)
  docker pull bitnami/nginx:"$PROX_EG_NGINX_VRSN"
  # Dev Env
  docker pull sonarqube:"$SONARQUBE_VRSN"
  docker pull sonarsource/sonar-scanner-cli:"$SONAR_SCANNER_VRSN"
}

if [ "pull-aot" == "$1" ]; then
  pull_aot
fi

# Utility to stop and remove if existing
safe_stop_remove() {
  OLD="$(docker ps --all --quiet --filter=name="$1")"
  if [ -n "$OLD" ]; then
    echo "Removing existing container: $1 ..."
    docker stop "$OLD" && docker rm "$OLD"
  fi
}

# Utility to remove containers in crash loop or constantly restarting/unhealthy
smart_stop_remove() {
  OLD_STATE="$( docker container inspect -f '{{.State.Status}}' "$1" 2> /dev/null )"
  if [ "$OLD_STATE" != "running" ]; then
    echo "$1 container not running..."
    safe_stop_remove "$1"
  fi
}
