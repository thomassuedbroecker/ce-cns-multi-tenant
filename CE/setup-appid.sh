#!/bin/bash

# **************** Global variables

export RESOURCE_GROUP=default
export REGION="us-south"
export SERVICE_PLAN="lite"
export APPID_SERVICE_NAME="appid"
export YOUR_SERVICE_FOR_APPID="appID-multi-tenancy-example-tsuedbro"
# "AppID-multi-tenancy"

# **************** Functions ****************************

createAppIDService() {
    ibmcloud target -g $RESOURCE_GROUP
    ibmcloud target -r $REGION
    ibmcloud catalog service-marketplace | grep $APPID_SERVICE_NAME
    # Create AppID service
    ibmcloud resource service-instance-create $YOUR_SERVICE_FOR_APPID $APPID_SERVICE_NAME $SERVICE_PLAN $REGION
    # Show AppID service instance details
    ibmcloud resource service-instance $YOUR_SERVICE_FOR_APPID
    # Get existing service keys for the service
    ibmcloud resource service-keys --instance-name $YOUR_SERVICE_FOR_APPID
    # Get the details for the service keys for the service
    ibmcloud resource service-keys --instance-name $YOUR_SERVICE_FOR_APPID --output json
    # Get the tenantId of the AppID service key
    export TENANTID=$(ibmcloud resource service-keys --instance-name $YOUR_SERVICE_FOR_APPID --output json | grep "tenantId" | awk '{print $2;}' | sed 's/"//g')
    echo $TENANTID
    # Get the managementUrl of the AppID service key
    export managementUrl=$(ibmcloud resource service-keys --instance-name $YOUR_SERVICE_FOR_APPID --output json | grep "managementUrl" | awk '{print $2;}' | sed 's/"//g' | sed 's/,//g')
    echo $managementUrl
}

getUsersAppIDService() {
    # Get OAUTHTOKEN for IAM IBM Cloud
    export OAUTHTOKEN=$(ibmcloud iam oauth-tokens | awk '{print $4;}')
    echo $OAUTHTOKEN
    # Invoke a get users curl command
    curl -i $managementUrl/users -H "Authorization: Bearer $OAUTHTOKEN"
    # Invoke a export users curl command
    curl -i $managementUrl/users/export -H "Authorization: Bearer $OAUTHTOKEN"
    # Invoke a export get redirect uris
    curl -i $managementUrl/config/redirect_uris -H "Authorization: Bearer $OAUTHTOKEN"
}



# **********************************************************************************

echo "************************************"
echo " Create AppID service"
echo "************************************"

createAppIDService



