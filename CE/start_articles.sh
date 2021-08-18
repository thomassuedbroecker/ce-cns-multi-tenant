#!/bin/bash
export HOME_PATH_NEW=$HOME_PATH
echo "************************************"
echo "$HOME_PATH_NEW and $HOME_PATH"
echo "************************************"
export NAME=articles-data-tenant
export MICROSERVICE="$HOME_PATH/../code/$NAME"
export MESSAGE="Starting $NAME"

echo "************************************"
echo "    $MESSAGE"
echo "************************************"

cd $MICROSERVICE
# Don't start quarkus in dev-mode
# https://adambien.blog/roller/abien/entry/avoiding_port_collisions_by_launching
mvn clean
mvn compile -Ddebug=false quarkus:dev