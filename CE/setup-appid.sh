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
export USER_IMPORT_FILE="./user-import.json"
export USER_EXPORT_FILE="./user-export.json"
export ENCRYPTION_SECRET="12345678"

# Application
export ADD_APPLICATION="./add-application.json"
export APPLICATION_CLIENTID=""
export APPLICATION_TENANTID=""
export APPLICATION_OAUTHSERVERURL=""



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
    # Get the managementUrl of the AppID service key
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

configureAppIDService(){
    # Get OAUTHTOKEN for IAM IBM Cloud
    OAUTHTOKEN=$(ibmcloud iam oauth-tokens | awk '{print $4;}')
    #echo "Auth Token: $OAUTHTOKEN"
    echo ""
    echo "-------------------------"
    echo " Create application"
    echo "-------------------------"
    echo ""
    result=$(curl -d @./$ADD_APPLICATION -H "Content-Type: application/json" -H "Authorization: Bearer $OAUTHTOKEN" $MANAGEMENTURL/applications)
    APPLICATION_CLIENTID=$(echo "$result" | grep "clientId" | awk '{print $2;}' | sed 's/"//g' | sed 's/,//g')
    APPLICATION_CLIENTID=$(echo "$result" | grep "clientId" | awk '{print $2;}' | sed 's/"//g' | sed 's/,//g')
    # Get OAUTHTOKEN for IAM IBM Cloud
    OAUTHTOKEN=$(ibmcloud iam oauth-tokens | awk '{print $4;}')
    #echo "Auth Token: $OAUTHTOKEN"
    echo ""
    echo "-------------------------"
    echo " Create application"
    echo "-------------------------"
    echo ""
    result=$(curl -d @./$ADD_APPLICATION -H "Content-Type: application/json" -H "Authorization: Bearer $OAUTHTOKEN" $MANAGEMENTURL/applications)
    echo "Result: $result"
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
    echo "$USER_EXPORT" > $USER_EXPORT_FILE
    echo ""
}

# **********************************************************************************

echo "************************************"
echo " Create AppID service"
echo "************************************"

createAppIDService

echo "************************************"
echo " Get AppID Information "
echo "************************************"

getUsersAppIDService

echo "************************************"
echo " Export AppID Information "
echo "************************************"

exportAppIDInformation

echo "************************************"
echo " Configure AppID Information "
echo "************************************"

# configureAppIDInformation



