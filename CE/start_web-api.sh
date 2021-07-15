#!/bin/bash
export HOME_PATH=/Users/thomassuedbroecker/Downloads/dev/ce-cns-private/CE
export NAME=web-api-tenant
export MICROSERVICE="$HOME_PATH/../code/$NAME"
export MESSAGE="Starting $NAME"

echo "************************************"
echo "    $MESSAGE"
echo "************************************"

cd $MICROSERVICE
mvn clean package quarkus:dev