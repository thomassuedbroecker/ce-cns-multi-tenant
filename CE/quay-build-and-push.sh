#!/bin/bash
#export REPOSITORY=$MY_REPOSITORY
export REPOSITORY=tsuedbroecker

cd ..
export ROOT_PATH=$(PWD)
echo "Path: $ROOT_PATH"

echo "************************************"
echo " web-app"
echo "************************************"
cd $ROOT_PATH/code/web-app-tenant-a
docker login quay.io
docker build -t "quay.io/$REPOSITORY/web-app-ce-appid:v2" -f Dockerfile.nginx .
docker push "quay.io/$REPOSITORY/web-app-ce-appid:v2"

echo ""

echo "************************************"
echo " articles"
echo "************************************"
cd $ROOT_PATH/code/articles-data-tenant
docker login quay.io
docker build -t "quay.io/$REPOSITORY/articles-ce-appid:v2" -f Dockerfile .
docker push "quay.io/$REPOSITORY/articles-ce-appid:v2"

echo ""

echo "************************************"
echo " web-api"
echo "************************************"

cd $ROOT_PATH/code/web-api-tenant
docker login quay.io
docker build -t "quay.io/$REPOSITORY/web-api-ce-appid:v2" -f Dockerfile .
docker push "quay.io/$REPOSITORY/web-api-ce-appid:v2"