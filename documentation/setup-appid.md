# Automated setup of AppID

These are the implementation details of the bash script part to setup the AppID service.

### 1. Create AppID service

This section used the IBM Cloud CLI.

#### a. Login to the IBM Cloud CLI

```sh
ibmcloud login
```

#### b. Set the region and resource group

```sh
ibmcloud target -g $RESOURCE_GROUP
ibmcloud target -r $REGION
```

#### c. Create service instance

```sh
ibmcloud resource service-instance-create $YOUR_SERVICE_FOR_APPID $APPID_SERVICE_NAME $SERVICE_PLAN $REGION
```

#### d. Create a service key for the AppID service

```sh
ibmcloud resource service-key-create $APPID_SERVICE_KEY_NAME $APPID_SERVICE_KEY_ROLE --instance-name $YOUR_SERVICE_FOR_APPID
```

### 2. Configure AppID service

#### a. Set identity providers

Here deactivate all identity providers accept t

```sh
OAUTHTOKEN=$(ibmcloud iam oauth-tokens | awk '{print $4;}')
result=$(curl -d @./idps-custom.json -X PUT -H "Content-Type: application/json" -H "Authorization: Bearer $OAUTHTOKEN" $MANAGEMENTURL/config/idps/custom)
```

#### b. Create application

#### c. Add scope

#### d. Add role

#### Import users