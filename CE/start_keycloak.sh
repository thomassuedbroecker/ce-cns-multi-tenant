#!/bin/bash
export HOME_PATH_NEW=$HOME_PATH
echo "************************************"
echo "$HOME_PATH_NEW and $HOME_PATH"
echo "************************************"
export MESSAGE="Starting Keycloak"

echo "************************************"
echo "    $MESSAGE"
echo "************************************"
#docker run -it -e KEYCLOAK_USER=admin -e KEYCLOAK_PASSWORD=admin -p 8282:8080 jboss/keycloak:9.0.2
podman run -it -e KEYCLOAK_USER=admin -e KEYCLOAK_PASSWORD=admin -p 8282:8080 "quay.io/keycloak/keycloak:10.0.2"
pwd