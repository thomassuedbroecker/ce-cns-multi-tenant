#!/bin/bash

# Information related to the REST API for AppID: 
# Link: https://github.com/ibm-cloud-security/appid-postman

# **************** Global variables

export RESOURCE_GROUP=default
#export REGION="us-south"
export REGION="eu-de"
export SERVICE_PLAN="lite"
export APPID_SERVICE_NAME="appid"
#export YOUR_SERVICE_FOR_APPID="appID-multi-tenancy-example-tsuedbro"
export YOUR_SERVICE_FOR_APPID="multi-tenancy-AppID"
export APPID_SERVICE_KEY_NAME="multi-tenancy-AppID-service-key"
export APPID_SERVICE_KEY_ROLE="Manager"
export TENANTID=""
export MANAGEMENTURL=""
# "AppID-multi-tenancy"

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
    export OAUTHTOKEN=$(ibmcloud iam oauth-tokens | awk '{print $4;}')
    echo "Auth Token: $OAUTHTOKEN"
    # Invoke get users curl command
    echo "-------------------------"
    echo " List users"
    echo "-------------------------"
    curl -i $MANAGEMENTURL/users -H "Authorization: Bearer $OAUTHTOKEN"
    # Invoke a export users curl command
    echo "-------------------------"
    echo " Export users"
    echo "-------------------------"
    curl -i $MANAGEMENTURL/users/export -H "Authorization: Bearer $OAUTHTOKEN"
    # Invoke get redirect uris
    echo "-------------------------"
    echo " List uris"
    echo "-------------------------"
    curl -i $MANAGEMENTURL/config/redirect_uris -H "Authorization: Bearer $OAUTHTOKEN"
    # Invoke get applications
    echo "-------------------------"
    echo " List applications"
    echo "-------------------------"
    curl -i $MANAGEMENTURL/applications -H "Authorization: Bearer $OAUTHTOKEN"
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



