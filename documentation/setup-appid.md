# Automated setup of AppID

These are the implementation details of the bash script to setup the AppID service.
We utilies following API and ClI in the scipt:
* [AppID swagger API documentation](https://us-south.appid.cloud.ibm.com/swagger-ui/#/).
* [IBM Cloud CLI](https://cloud.ibm.com/docs/cli?topic=cli-getting-started)

The script creates one instance of the AppID service and does the configuration.

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

Deactivate Google, Custom and Facebook as identity providers.

```sh
OAUTHTOKEN=$(ibmcloud iam oauth-tokens | awk '{print $4;}')
result=$(curl -d @./idps-custom.json -X PUT -H "Content-Type: application/json" -H "Authorization: Bearer $OAUTHTOKEN" $MANAGEMENTURL/config/idps/custom)
```

The files do contain following format.

```json
{
    "isActive": false
}
```

Enable Cloud Directory as identity provider.

```json
{
  "isActive": true,
  "config": {
    "selfServiceEnabled": true,
    "signupEnabled": true,
    "interactions": {
      "identityConfirmation": {
        "accessMode": "FULL",
        "methods": [
          "email"
        ]
      },
      "welcomeEnabled": false,
      "resetPasswordEnabled": false,
      "resetPasswordNotificationEnable": true
    },
    "identityField": "email"
  }
}
```

#### b. Create application

```sh
result=$(curl -d @./$ADD_APPLICATION -H "Content-Type: application/json" -H "Authorization: Bearer $OAUTHTOKEN" $MANAGEMENTURL/applications)
```

```json
{
    "name": "cns-ce-example",
    "type": "singlepageapp"
}
```

#### c. Add scope

```sh
result=$(curl -d @./$ADD_SCOPE -H "Content-Type: application/json" -X PUT -H "Authorization: Bearer $OAUTHTOKEN" $MANAGEMENTURL/applications/$APPLICATION_CLIENTID/scopes)
``` 

```json
{
  "scopes": [
    "cns_example_scope"
  ]
}
```

#### d. Add role

```sh
#Create file from template
sed "s+APPLICATIONID+$APPLICATION_CLIENTID+g" ./add-roles-template.json > ./$ADD_ROLE
OAUTHTOKEN=$(ibmcloud iam oauth-tokens | awk '{print $4;}')
#echo $OAUTHTOKEN
result=$(curl -d @./$ADD_ROLE -H "Content-Type: application/json" -X POST -H "Authorization: Bearer $OAUTHTOKEN" $MANAGEMENTURL/roles)
``` 

```json
{
  "name": "ce_user_access",
  "description": "This is an example role.",
  "access": [
    {
      "application_id": "APPLICATIONID",
      "scopes": [
        "cns_example_scope"
      ]
    }
  ]
}
```

#### e. Import users

```sh
result=$(curl -d @./$USER_IMPORT_FILE -H "Content-Type: application/json" -X POST -H "Authorization: Bearer $OAUTHTOKEN" $MANAGEMENTURL/cloud_directory/import?encryption_secret=$ENCRYPTION_SECRET)
```

Format of an exported user, which will be imported.

```json
{"itemsPerPage":1,"totalResults":1,"users":[{"scimUser":{"originalId":"7cdf7ac3-371f-4b4c-8d0a-81e479ab449b","name":{"givenName":"Thomas","familyName":"Example","formatted":"Thomas Example"},"displayName":"Thomas Example","active":true,"emails":[{"value":"thomas@example.com","primary":true}],"passwordHistory":[{"passwordHash":"L6EEYnQANBPSBF0tDCPDZl4uVD07H3Ur8qIVynB1Ht4Bn4s/x0lA6kvyJxEPr/06m5hi5wdLM45JtYDlT8M0hjVIBI3YpXRR9J4oXZA/Yt/V13yjsUPsXKek6RWdOKWp+wuD5w3Bobh43QbRR3dXFoKUbcLVWQoKLWqvRATMQis=","hashAlgorithm":"PBKDF2WithHmacSHA512"}],"status":"CONFIRMED","passwordExpirationTimestamp":0,"passwordUpdatedTimestamp":0,"mfaContext":{}},"passwordHash":"L6EEYnQANBPSBF0tDCPDZl4uVD07H3Ur8qIVynB1Ht4Bn4s/x0lA6kvyJxEPr/06m5hi5wdLM45JtYDlT8M0hjVIBI3YpXRR9J4oXZA/Yt/V13yjsUPsXKek6RWdOKWp+wuD5w3Bobh43QbRR3dXFoKUbcLVWQoKLWqvRATMQis=","passwordHashAlg":"PBKDF2WithHmacSHA512","profile":{"attributes":{}},"roles":["ce_user_access"]}]}
```

#### f. Add redirect URLs

```sh
OAUTHTOKEN=$(ibmcloud iam oauth-tokens | awk '{print $4;}')
result=$(curl -d @./$ADD_REDIRECT_URIS -H "Content-Type: application/json" -X PUT -H "Authorization: Bearer $OAUTHTOKEN" $MANAGEMENTURL/config/redirect_uris)
```

```json
{
    "redirectUris": [
      "http://localhost:8080/*",
      "APPLICATION_REDIRECT_URL/*"
    ],
    "additionalProp1": {}
}
```


