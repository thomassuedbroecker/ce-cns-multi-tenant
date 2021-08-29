#!/bin/bash
# https://scriptingosx.com/2020/03/macos-shell-command-to-create-a-new-terminal-window/
export HOME_PATH=$(pwd)
echo "HOME_PATH: " $HOME_PATH

# bash scripts
export WEB_APP_TENANT_A="$HOME_PATH/start_vue-tenant_A.sh"
export WEB_API="$HOME_PATH/start_web-api.sh"
export ARTICLES="$HOME_PATH/start_articles.sh"

echo "************************************"
echo "    Configure for execution"
echo "************************************"
chmod 755 $WEB_APP_SELECT
chmod 755 $WEB_API
chmod 755 $ARTICLES

echo "************************************"
echo "    Open Terminals"
echo "************************************"

open -a Terminal $WEB_APP_TENANT_A 
open -a Terminal $WEB_API 
open -a Terminal $ARTICLES 

echo "************************************"
echo "    Open Browser"
echo "************************************"
open -a "Google Chrome" http://localhost:8080
