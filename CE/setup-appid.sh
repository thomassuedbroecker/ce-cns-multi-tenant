#!/bin/bash

# Information related to the REST API for AppID: 
# Link: https://github.com/ibm-cloud-security/appid-postman

# **************** Global variables

export RESOURCE_GROUP=default
#export REGION="us-south"
export REGION="eu-de"

# "AppID-multi-tenancy"

# Service
export SERVICE_PLAN="lite"
export APPID_SERVICE_NAME="appid"
#export YOUR_SERVICE_FOR_APPID="appID-multi-tenancy-example-tsuedbro"
export YOUR_SERVICE_FOR_APPID="multi-tenancy-AppID"
export APPID_SERVICE_KEY_NAME="multi-tenancy-AppID-service-key"
export APPID_SERVICE_KEY_ROLE="Manager"
export TENANTID=""
export MANAGEMENTURL=""

# User
export USER_IMPORT_FILE="user-import.json"
export USER_EXPORT_FILE="user-export.json"
export ENCRYPTION_SECRET="12345678"

# Application
export ADD_APPLICATION="add-application.json"
export ADD_SCOPE="add-scope.json"
export ADD_ROLE="add-roles.json"
export APPLICATION_CLIENTID=""
export APPLICATION_TENANTID=""
export APPLICATION_DISCOVERYENDPOINT=""
export APPLICATION_OAUTHSERVERURL=""
export APPLICATION_REDIRCT_URIS="add-redirecturis.json"

# **************** Functions ****************************

createAppIDService() {
    ibmcloud target -g $RESOURCE_GROUP
    ibmcloud target -r $REGION
    #List AppID service in marketplace
    #ibmcloud catalog service-marketplace | grep $APPID_SERVICE_NAME
    # Create AppID service
    #ibmcloud resource service-instance-create $YOUR_SERVICE_FOR_APPID $APPID_SERVICE_NAME $SERVICE_PLAN $REGION
    # Show AppID service instance details
    ibmcloud resource service-instance $YOUR_SERVICE_FOR_APPID
    # Create a service key for the service
    #ibmcloud resource service-key-create $APPID_SERVICE_KEY_NAME $APPID_SERVICE_KEY_ROLE --instance-name $YOUR_SERVICE_FOR_APPID
    # Get existing service keys for the service
    ibmcloud resource service-keys --instance-name $YOUR_SERVICE_FOR_APPID
    # Get the details for the service keys for the service
    ibmcloud resource service-keys --instance-name $YOUR_SERVICE_FOR_APPID --output json
    # Get the tenantId of the AppID service key
    TENANTID=$(ibmcloud resource service-keys --instance-name $YOUR_SERVICE_FOR_APPID --output json | grep "tenantId" | awk '{print $2;}' | sed 's/"//g')
    echo "Tenant ID: $TENANTID"
    # Get the managementUrl of the AppID from service key
    MANAGEMENTURL=$(ibmcloud resource service-keys --instance-name $YOUR_SERVICE_FOR_APPID --output json | grep "managementUrl" | awk '{print $2;}' | sed 's/"//g' | sed 's/,//g')
    echo "Management URL: $MANAGEMENTURL"
}

getUsersAppIDService() {
    # Get OAUTHTOKEN for IAM IBM Cloud
    OAUTHTOKEN=$(ibmcloud iam oauth-tokens | awk '{print $4;}')
    #echo "Auth Token: $OAUTHTOKEN"
    # Invoke get users curl command
    echo ""
    echo "-------------------------"
    echo " List users"
    echo "-------------------------"
    echo ""
    #curl -i $MANAGEMENTURL/users -H "Authorization: Bearer $OAUTHTOKEN"
    curl $MANAGEMENTURL/users -H "Authorization: Bearer $OAUTHTOKEN"
    # Invoke a list redirects curl command
    echo ""
    echo "-------------------------"
    echo " List redirects uris"
    echo "-------------------------"
    echo ""
    #curl -i $MANAGEMENTURL/users/export -H "Authorization: Bearer $OAUTHTOKEN"
    curl $MANAGEMENTURL/config/redirect_uris -H "Authorization: Bearer $OAUTHTOKEN"
    # Invoke get applications
    echo ""
    echo "-------------------------"
    echo " List applications"
    echo "-------------------------"
    #curl -i $MANAGEMENTURL/applications -H "Authorization: Bearer $OAUTHTOKEN"
    curl $MANAGEMENTURL/applications -H "Authorization: Bearer $OAUTHTOKEN"
    echo ""
}

configureAppIDInformation(){
    # Get OAUTHTOKEN for IAM IBM Cloud
    #OAUTHTOKEN=$(ibmcloud iam oauth-tokens | awk '{print $4;}')
    #echo "Auth Token: $OAUTHTOKEN"

    #****** Set identity providers
    echo ""
    echo "-------------------------"
    echo " Set identity providers"
    echo "-------------------------"
    echo ""
    OAUTHTOKEN=$(ibmcloud iam oauth-tokens | awk '{print $4;}')
    result=$(curl -d @./idps-custom.json -X PUT -H "Content-Type: application/json" -H "Authorization: Bearer $OAUTHTOKEN" $MANAGEMENTURL/config/idps/custom)
    echo ""
    echo "-------------------------"
    echo "Result custom: $result"
    echo "-------------------------"
    echo ""
    OAUTHTOKEN=$(ibmcloud iam oauth-tokens | awk '{print $4;}')
    result=$(curl -d @./idps-facebook.json -X PUT -H "Content-Type: application/json" -H "Authorization: Bearer $OAUTHTOKEN" $MANAGEMENTURL/config/idps/facebook)
    echo ""
    echo "-------------------------"
    echo "Result facebook: $result"
    echo "-------------------------"
    echo ""
    OAUTHTOKEN=$(ibmcloud iam oauth-tokens | awk '{print $4;}')
    result=$(curl -d @./idps-google.json -X PUT -H "Content-Type: application/json" -H "Authorization: Bearer $OAUTHTOKEN" $MANAGEMENTURL/config/idps/google)
    echo ""
    echo "-------------------------"
    echo "Result google: $result"
    echo "-------------------------"
    echo ""
    OAUTHTOKEN=$(ibmcloud iam oauth-tokens | awk '{print $4;}')
    result=$(curl -d @./idps-clouddirectory.json -X PUT -H "Content-Type: application/json" -H "Authorization: Bearer $OAUTHTOKEN" $MANAGEMENTURL/config/idps/cloud_directory)
    echo ""
    echo "-------------------------"
    echo "Result cloud directory: $result"
    echo "-------------------------"
    echo ""

    #****** Add application ******
    echo ""
    echo "-------------------------"
    echo " Create application"
    echo "-------------------------"
    echo ""
    result=$(curl -d @./$ADD_APPLICATION -H "Content-Type: application/json" -H "Authorization: Bearer $OAUTHTOKEN" $MANAGEMENTURL/applications)
    echo "-------------------------"
    echo "Result application: $result"
    echo "-------------------------"
    #APPLICATION_CLIENTID=$(echo $result | grep 'clientId' | awk '{print $2;}' | sed 's/"//g' | sed 's/,//g')
    APPLICATION_CLIENTID=$(echo $result | sed -n 's|.*"clientId":"\([^"]*\)".*|\1|p')
    #APPLICATION_TENANTID=$(echo $result | grep "tenantId" | awk '{print $2;}' | sed 's/"//g' | sed 's/,//g')
    APPLICATION_TENANTID=$(echo $result | sed -n 's|.*"tenantId":"\([^"]*\)".*|\1|p')
    #APPLICATION_OAUTHSERVERURL=$(echo "$result" | grep "oAuthServerUrl" | awk '{print $2;}' | sed 's/"//g' | sed 's/,//g')
    APPLICATION_OAUTHSERVERURL=$(echo $result | sed -n 's|.*"oAuthServerUrl":"\([^"]*\)".*|\1|p')
    APPLICATION_DISCOVERYENDPOINT=$(echo $result | sed -n 's|.*"discoveryEndpoint":"\([^"]*\)".*|\1|p')

    echo "ClientID: $APPLICATION_CLIENTID"
    echo "TenantID: $APPLICATION_TENANTID"
    echo "oAuthServerUrl: $APPLICATION_OAUTHSERVERURL"
    echo "discoveryEndpoint: $APPLICATION_DISCOVERYENDPOINT"
    echo ""

    #****** Add scope ******
    echo ""
    echo "-------------------------"
    echo " Add scope"
    echo "-------------------------"

    OAUTHTOKEN=$(ibmcloud iam oauth-tokens | awk '{print $4;}')
    result=$(curl -d @./$ADD_SCOPE -H "Content-Type: application/json" -X PUT -H "Authorization: Bearer $OAUTHTOKEN" $MANAGEMENTURL/applications/$APPLICATION_CLIENTID/scopes)
    echo "-------------------------"
    echo "Result scope: $result"
    echo "-------------------------"
    echo ""

    #****** Add role ******
    echo "-------------------------"
    echo " Add role"
    echo "-------------------------"
    #Create file from template
    sed "s+APPLICATIONID+$APPLICATION_CLIENTID+g" ./add-roles-template.json > ./$ADD_ROLE
    OAUTHTOKEN=$(ibmcloud iam oauth-tokens | awk '{print $4;}')
    #echo $OAUTHTOKEN
    result=$(curl -d @./$ADD_ROLE -H "Content-Type: application/json" -X POST -H "Authorization: Bearer $OAUTHTOKEN" $MANAGEMENTURL/roles)
    echo "-------------------------"
    echo "Result role: $result"
    echo "-------------------------"
    echo ""
 
    #****** Import cloud directory users ******
    echo ""
    echo "-------------------------"
    echo " Cloud directory import users"
    echo "-------------------------"
    echo ""
    OAUTHTOKEN=$(ibmcloud iam oauth-tokens | awk '{print $4;}')
    result=$(curl -d @./$USER_IMPORT_FILE -H "Content-Type: application/json" -X POST -H "Authorization: Bearer $OAUTHTOKEN" $MANAGEMENTURL/cloud_directory/import?encryption_secret=$ENCRYPTION_SECRET)
    echo "-------------------------"
    echo "Result import: $result"
    echo "-------------------------"
    echo ""
    
    #****** Add redirect uris ******
    echo ""
    echo "-------------------------"
    echo " Add redirect usis"
    echo "-------------------------"
    echo ""
    curl $MANAGEMENTURL/config/redirect_uris -H "Authorization: Bearer $OAUTHTOKEN"
    result=$(curl -d @./$USER_IMPORT_FILE -H "Content-Type: application/json" -X POST -H "Authorization: Bearer $OAUTHTOKEN" $MANAGEMENTURL/cloud_directory/import?encryption_secret=$ENCRYPTION_SECRET)
    echo "-------------------------"
    echo "Result import: $result"
    echo "-------------------------"
    echo ""
}

exportAppIDInformation(){
    # Invoke a cloud directory export users curl command
    echo ""
    echo "-------------------------"
    echo " Cloud directory export users"
    echo "-------------------------"
    echo ""
    # Get OAUTHTOKEN for IAM IBM Cloud
    export OAUTHTOKEN=$(ibmcloud iam oauth-tokens | awk '{print $4;}')
    USER_EXPORT=$(curl $MANAGEMENTURL/cloud_directory/export?encryption_secret=$ENCRYPTION_SECRET -H "Authorization: Bearer $OAUTHTOKEN")
    echo ""
    echo "$USER_EXPORT" > ./$USER_EXPORT_FILE
    echo ""
}

# **********************************************************************************

echo "************************************"
echo " Create AppID service"
echo "************************************"

createAppIDService

#echo "************************************"
#echo " Get AppID Information "
#echo "************************************"

getUsersAppIDService

#echo "************************************"
#echo " Export AppID Information "
#echo "************************************"

#exportAppIDInformation

echo "************************************"
echo " Configure AppID Information "
echo "************************************"

#configureAppIDInformation



