#!/bin/bash
export HOME_PATH_NEW=$HOME_PATH
echo "************************************"
echo "$HOME_PATH_NEW and $HOME_PATH"
echo "************************************"
export APP_NAME=web-app-tenant-a
export WEB_APP="$HOME_PATH_NEW/../code/$APP_NAME"
export MESSAGE="Starting 'Tenant-A Web-App'"

echo "************************************"
echo "    $MESSAGE"
echo "************************************"

cd $WEB_APP
yarn install
yarn serve