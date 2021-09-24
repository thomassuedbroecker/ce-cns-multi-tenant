#!/bin/bash
export REPOSITORY=$MY_REPOSITORY

cd ..
export ROOT_PATH=$(PWD)
echo "Path: $ROOT_PATH"

echo "************************************"
echo " web-app"
echo "************************************"
cd $ROOT_PATH/code/web-app-tenant-a
podman login quay.io
podman build -t "quay.io/$REPOSITORY/web-app-ce-appid:v1" -f Dockerfile.os4-webapp .
podman push "quay.io/$REPOSITORY/web-app-ce-appid:v1"

echo ""

echo "************************************"
echo " articles"
echo "************************************"
cd $ROOT_PATH/code/articles-tenant
docker login quay.io
docker build -t "quay.io/$REPOSITORY/articles-ce-appid:v1" -f Dockerfile .
docker push "quay.io/$REPOSITORY/articles-ce-appid:v1"

echo ""

echo "************************************"
echo " web-api"
echo "************************************"

cd $ROOT_PATH/code/web-api-tenant
docker login quay.io
docker build -t "quay.io/$REPOSITORY/web-api-ce-appid:v1" -f Dockerfile .
docker push "quay.io/$REPOSITORY/web-api-ce-appid:v1"