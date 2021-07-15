#!/bin/bash
export HOME_PATH=/Users/thomassuedbroecker/Downloads/dev/ce-cns-private/CE
export MESSAGE="Starting Keycloak"

echo "************************************"
echo "    $MESSAGE"
echo "************************************"
docker run -it -e KEYCLOAK_USER=admin -e KEYCLOAK_PASSWORD=admin -p 8282:8080 jboss/keycloak:9.0.2
pwd