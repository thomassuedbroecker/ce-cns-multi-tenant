#!/bin/bash
export HOME_PATH=/Users/thomassuedbroecker/Downloads/dev/ce-cns-private/CE
export KEYCLOAK_URL=http://localhost:8282
export MESSAGE="Starting to configure Keycloak"

function createRealmsKeycloak() {
    echo "************************************"
    echo " Create Keycloak realms"
    echo "************************************"

    # Set the needed parameter authorization
    USER=admin
    PASSWORD=admin
    GRANT_TYPE=password
    CLIENT_ID=admin-cli

    # Set the needed parameter for configuration
    TENANT_A_DATA=cns-realm-tenant-A.json
    TENANT_B_DATA=cns-realm-tenant-B.json
    TENANT_A=tenantA
    TENANT_B=tenantB
    USERDATA=cns-tenantB-user.json

    access_token=$( curl -d "client_id=$CLIENT_ID" -d "username=$USER" -d "password=$PASSWORD" -d "grant_type=$GRANT_TYPE" "$KEYCLOAK_URL/auth/realms/master/protocol/openid-connect/token" | sed -n 's|.*"access_token":"\([^"]*\)".*|\1|p')
    echo "User : $USER/$PASSWORD" 
    echo "Access token : $access_token"

    # Create the realm in Keycloak
    echo "------------------------------------------------------------------------"
    echo "Create the realm in Keycloak"
    echo "------------------------------------------------------------------------"
    echo ""

    result=$(curl -d @./$TENANT_A_DATA -H "Content-Type: application/json" -H "Authorization: bearer $access_token" "$KEYCLOAK_URL/auth/admin/realms")

    if [ "$result" = "" ]; then
    echo "------------------------------------------------------------------------"
    echo "The realm is created."
    echo "Open following link in your browser:"
    echo "$KEYCLOAK_URL/auth/admin/master/console/#/realms/$TENANT_A"
    echo "------------------------------------------------------------------------"
    else
    echo "------------------------------------------------------------------------"
    echo "It seems there is a problem with the realm creation: $result"
    echo "------------------------------------------------------------------------"
    fi

    result=$(curl -d @./$TENANT_B_DATA -H "Content-Type: application/json" -H "Authorization: bearer $access_token" "$KEYCLOAK_URL/auth/admin/realms")

    if [ "$result" = "" ]; then
    echo "------------------------------------------------------------------------"
    echo "The realm is created."
    echo "Open following link in your browser:"
    echo "$KEYCLOAK_URL/auth/admin/master/console/#/realms/$TENANT_B"
    echo "------------------------------------------------------------------------"
    else
    echo "------------------------------------------------------------------------"
    echo "It seems there is a problem with the realm creation: $result"
    echo "------------------------------------------------------------------------"
    fi
     
    # https://www.appsdeveloperblog.com/keycloak-rest-api-create-a-new-user/ 
    result=$(curl -d @./$USERDATA -H "Content-Type: application/json" -H "Authorization: bearer $access_token" "$KEYCLOAK_URL/auth/admin/realms/$TENANT_B/users")

    if [ "$result" = "" ]; then
    echo "------------------------------------------------------------------------"
    echo "The password is created."
    echo "Open following link in your browser:"
    echo "$KEYCLOAK_URL/auth/admin/master/console/#/realms/$TENANT_A"
    echo "------------------------------------------------------------------------"
    else
    echo "------------------------------------------------------------------------"
    echo "It seems there is a problem with the realm creation: $result"
    echo "------------------------------------------------------------------------"
    fi
}


function createUserKeycloak() {
    echo "************************************"
    echo " Create Keycloak user"
    echo "************************************"

    # Set the needed parameter authorization
    USER=admin
    PASSWORD=admin
    GRANT_TYPE=password
    CLIENT_ID=admin-cli

    # Set the needed parameter for configuration
    TENANT_A=tenantA
    TENANT_B=tenantB
    USERDATA=cns-tenantB-user.json

    access_token=$( curl -d "client_id=$CLIENT_ID" -d "username=$USER" -d "password=$PASSWORD" -d "grant_type=$GRANT_TYPE" "$KEYCLOAK_URL/auth/realms/master/protocol/openid-connect/token" | sed -n 's|.*"access_token":"\([^"]*\)".*|\1|p')
    echo "User : $USER/$PASSWORD" 
    echo "Access token : $access_token"
  
    # https://www.appsdeveloperblog.com/keycloak-rest-api-create-a-new-user/ 
    result=$(curl -d @./$USERDATA -H "Content-Type: application/json" -H "Authorization: bearer $access_token" "$KEYCLOAK_URL/auth/admin/realms/$TENANT_B/users")

    if [ "$result" = "" ]; then
    echo "------------------------------------------------------------------------"
    echo "The user is created."
    echo "Open following link in your browser:"
    echo "$KEYCLOAK_URL/auth/admin/master/console/#/realms/$TENANT_A"
    echo "------------------------------------------------------------------------"
    else
    echo "------------------------------------------------------------------------"
    echo "It seems there is a problem with the user creation: $result"
    echo "------------------------------------------------------------------------"
    fi
}

echo "************************************"
echo "    $MESSAGE"
echo "************************************"
sleep 65
cd $HOME_PATH
createRealmsKeycloak
createUserKeycloak
pwd