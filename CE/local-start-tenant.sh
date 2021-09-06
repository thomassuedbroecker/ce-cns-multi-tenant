#!/bin/bash
# https://scriptingosx.com/2020/03/macos-shell-command-to-create-a-new-terminal-window/
export HOME_PATH=$(pwd)
export PODMAN_REGISTRY=quay.io 
echo "HOME_PATH: " $HOME_PATH
podman login $PODMAN_REGISTRY

# bash scripts
export WEB_APP_SELECT="$HOME_PATH/start_vue-select.sh"
export WEB_APP_TENANT_A="$HOME_PATH/start_vue-tenant_A.sh"
export WEB_APP_TENANT_B="$HOME_PATH/start_vue-tenant_B.sh"
export KEYCLOAK="$HOME_PATH/start_keycloak.sh"
export CONFIGURE_KEYCLOAK="$HOME_PATH/start_configure_keycloak.sh"
export WEB_API="$HOME_PATH/start_web-api.sh"
export ARTICLES="$HOME_PATH/start_articles.sh"

# urls
export WEB_APP_SELECT_URL="http://localhost:8080"
export KEYCLOAK_URL="http://localhost:8282"

echo "************************************"
echo "    Configure for execution"
echo "************************************"
chmod 755 $WEB_APP_SELECT
chmod 755 $WEB_APP_TENANT_A
chmod 755 $WEB_APP_TENANT_B
chmod 755 $KEYCLOAK
chmod 755 $CONFIGURE_KEYCLOAK
chmod 755 $WEB_API
chmod 755 $ARTICLES

echo "************************************"
echo "    Open Terminals"
echo "************************************"
open -a Terminal $KEYCLOAK 
open -a Terminal $CONFIGURE_KEYCLOAK 
open -a Terminal $WEB_APP_SELECT
sleep 5
open -a Terminal $WEB_APP_TENANT_A 
sleep 5
open -a Terminal $WEB_APP_TENANT_B 
open -a Terminal $WEB_API 
open -a Terminal $ARTICLES 

echo "************************************"
echo "    Open Browser"
echo "************************************"
open -a "Google Chrome" $WEB_APP_SELECT_URL
open -a "Google Chrome" $KEYCLOAK_URL