#!/bin/bash
export HOME_PATH=/Users/thomassuedbroecker/Downloads/dev/ce-cns-private/CE
export APP_NAME=web-app-tenant-a
export WEB_APP="$HOME_PATH/../code/$APP_NAME"
export MESSAGE="Starting 'Tenant-A Web-App'"

echo "************************************"
echo "    $MESSAGE"
echo "************************************"

cd $WEB_APP
yarn install
yarn serve