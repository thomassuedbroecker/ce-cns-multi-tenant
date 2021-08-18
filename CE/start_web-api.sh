#!/bin/bash
export HOME_PATH_NEW=$HOME_PATH
echo "************************************"
echo "$HOME_PATH_NEW and $HOME_PATH"
echo "************************************"
export NAME=web-api-tenant
export MICROSERVICE="$HOME_PATH_NEW/../code/$NAME"
export MESSAGE="Starting $NAME"

echo "************************************"
echo "    $MESSAGE"
echo "************************************"

cd $MICROSERVICE
mvn clean package quarkus:dev