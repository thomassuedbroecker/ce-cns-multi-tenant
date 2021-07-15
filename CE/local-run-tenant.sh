#!/bin/bash

# **************** Global variables

ROOT_PATH="/Users/thomassuedbroecker/Downloads/dev/ce-cns"
OPTION=Y

# **************** Functions ****************************

function clean(){

    echo "Ok to kill all Docker process sessions? (Y)es/(N)o"
    read KILL
    if [ $KILL == $OPTION ];
    then
        echo "... Killing Docker processes ..."
        docker kill -$(docker ps -a -q)
    fi

    cd $ROOT_PATH/CE
    docker image rm "jboss/keycloak:9.0.2"
    docker image rm "articles-ce:v1"
    docker image rm "web-api-ce:v1"
    docker image rm "web-app-ce:v1"
}

# **********************************************************************************

echo "************************************"
echo " Clean"
echo "************************************"
clean

echo "************************************"
echo " Start keycloak"
echo "************************************"
docker run --name="keycloak" \
           -d \
           -e KEYCLOAK_USER=admin \
           -e KEYCLOAK_PASSWORD=admin \
           -p 8282:8080 \
           "jboss/keycloak:9.0.2"

echo "************************************"
echo " Build and run articles"
echo "************************************"
cd $ROOT_PATH/code/articles
# docker build -t "articles-tenant:v1" -f Dockerfile .
# docker run --name="articles" \
#            -d \
#            -e QUARKUS_OIDC_AUTH_SERVER_URL="http://localhost:8282/auth/realms/quarkus" \
#            -p 8083:8083 \
#            ""articles-tenant:v1"

echo "************************************"
echo " Build and run web-api"
echo "************************************"
cd $ROOT_PATH/code/web-api
# docker build -t "web-api-ce:v1" -f Dockerfile .
# docker run --name="web-api" \
#           -d \
#           -e QUARKUS_OIDC_AUTH_SERVER_URL="http://localhost:8282/auth/realms/quarkus" \
#           -e CNS_ARTICLES_URL="http://localhost:8083/articles" \
#           -p 8082:8082 \
#           "web-api-ce:v1"


echo "************************************"
echo " Build and run web-app-select"
echo "************************************"
cd $ROOT_PATH/code/web-app-select
docker build -t "web-app-select:v1" -f Dockerfile.os4-webapp .
docker run --name="web-app-select" \
           -d \
           -e VUE_APP_ROOT="/" \
           -e VUE_TENANT_A="http://localhost:8081" \
           -e VUE_TENANT_B="http://localhost:8083" \
           -p 8080:8080 \
           "web-app-select:v1"

echo " Build and run web-app-tenant-a"
echo "************************************"
cd $ROOT_PATH/code/web-app-tenant-a
docker build -t "web-app-tenant-a:v1" -f Dockerfile.os4-webapp .
docker run --name="web-app-tenant-a" \
           -d \
           -e VUE_APP_ROOT="/" \
           -e VUE_APP_KEYCLOAK="http://localhost:8282/auth" \
           -e VUE_APP_WEPAPI="http://localhost:8083" \
           -e VUE_REDIRECT_URL="http://localhost:8080" \
           -e VUE_REALM="tenantA"
           -p 8081:8081 \
           "web-app-tenant-a:v1"

echo " Build and run web-app-tenant-b"
echo "************************************"
cd $ROOT_PATH/code/web-app-tenant-a
docker build -t "web-app-tenant-b:v1" -f Dockerfile.os4-webapp .
docker run --name="web-app-tenant-b" \
           -d \
           -e VUE_APP_ROOT="/" \
           -e VUE_APP_KEYCLOAK="http://localhost:8282/auth" \
           -e VUE_APP_WEPAPI="http://localhost:8083" \
           -e VUE_REDIRECT_URL="http://localhost:8080" \
           -e VUE_REALM="tenantB"
           -p 8082:8082 \
           "web-app-tenant-b:v1"

