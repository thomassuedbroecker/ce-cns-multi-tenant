#!/bin/bash
export HOME_PATH=/Users/thomassuedbroecker/Downloads/dev/ce-cns-private/CE
export APP_NAME=web-app-select
export WEB_APP="$HOME_PATH/../code/$APP_NAME"
export MESSAGE="Starting 'Select Web-App'"

echo "************************************"
echo "    $MESSAGE"
echo "************************************"

cd $WEB_APP
yarn install
yarn serve