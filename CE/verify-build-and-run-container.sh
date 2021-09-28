#!/bin/bash

# **************** Global variables
export APPLICATION_CLIENTID='100924f6-bcf1-4bc7-a3bc-d00d2aa681ac'
export APPLICATION_OAUTHSERVERURL='https://eu-de.appid.cloud.ibm.com/oauth/v4/8f1ddb36-f860-4355-a870-8e0abe7124ef'
export APPLICATION_DISCOVERYENDPOINT='https://eu-de.appid.cloud.ibm.com/oauth/v4/8f1ddb36-f860-4355-a870-8e0abe7124ef/.well-known/openid-configuration'
export WEBAPI_URL="http://localhost:8082"
export ROOT_PATH=$(pwd)

echo "************************************"
echo " Verify container locally"
echo "************************************"

echo "************************************"
echo " Build and run web-app"
echo "************************************"
cd ..
pwd
cd code/web-app-tenant-a
#eval $(minikube -p minikube docker-env)
podman image list
#docker image list
podman container list
#docker container list
#podman image prune -a -f


podman build -t "web-app-local-verification:v1" -f Dockerfile.os4-webapp .
#docker build -t "web-app-local-verification:v1" -f Dockerfile.os4-webapp .
pwd

podman container list
podman logs web-app-verification
podman run --name="web-app-verification" \
           -it \
           -e VUE_APP_ROOT="/" \
           -e VUE_APP_WEBAPI="$WEBAPI_URL/articlesA" \
           -e VUE_APPID_CLIENT_ID="$APPLICATION_CLIENTID" \
           -e VUE_APPID_DISCOVERYENDPOINT="$APPLICATION_DISCOVERYENDPOINT" \
           -p 8080:8080/tcp \
           "web-app-local-verification:v1"

podman port --all  

#docker run --name="web-app-verification" \
#           -it \
#           -e VUE_APP_ROOT="/" \
#           -e VUE_APP_WEBAPI="$WEBAPI_URL/articlesA" \
#           -e VUE_APPID_CLIENT_ID="$APPLICATION_CLIENTID" \
#           -e VUE_APPID_DISCOVERYENDPOINT="$APPLICATION_DISCOVERYENDPOINT" \
#           -p 8080:8080 \
#           "web-app-local-verification:v1"


#podman run --name="web-app-verification" \
#           -d \
#           -e VUE_APP_ROOT="/" \
#           -e VUE_APP_WEBAPI="$WEBAPI_URL/articlesA" \
#           -e VUE_APPID_CLIENT_ID="$APPLICATION_CLIENTID" \
#           -e VUE_APPID_DISCOVERYENDPOINT="$APPLICATION_DISCOVERYENDPOINT" \
#           -p 8080:8080 \
#           "web-app-local-verification:v1"

#podman  attach web-app-verification