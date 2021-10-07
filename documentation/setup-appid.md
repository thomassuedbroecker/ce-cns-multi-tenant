# Automated setup of IBM Cloud App ID using a Bash script

These are some of the implementation details of an example Bash script to automate the setup for an [IBM Cloud App ID](https://www.ibm.com/cloud/app-id) service instance.

> _"IBM Cloud App ID allows you to easily add authentication to web and mobile apps. You no longer have to worry about setting up infrastructure for identity, ensuring geo-availability, and confirming compliance regulations. Instead, you can enhance your apps with advanced security capabilities like multifactor authentication and single sign-on."_ Resouce from the [IBM Cloud App ID](https://www.ibm.com/cloud/app-id) webpage (2021/10/06)

The Bash script utilies following APIs and ClIs:

* [AppID swagger API documentation](https://us-south.appid.cloud.ibm.com/swagger-ui/#/).
* [IBM Cloud CLI](https://cloud.ibm.com/docs/cli?topic=cli-getting-started)

The script creates one instance of the [IBM Cloud App ID](https://www.ibm.com/cloud/app-id) service and does the configuration.

The example setup uses the IBM Cloud Shell and a `PayAsYouGo` IBM Cloud Account, but for the App ID service instance we will use the lite plan which is for free. 

> Please take about the offical documentation for each [IBM Cloud Services](https://cloud.ibm.com/catalog) and [IBM Cloud Account types](https://cloud.ibm.com/docs/account?topic=account-accounts) definitions, before you start.

### Simplified overview of steps to setup an example using the Bash script:

1. Create a `PayAsYouGo` IBM Cloud Account
2. Open the IBM Cloud shell
3. Clone the [GitHub project](https://github.com/thomassuedbroecker/automated-setup-of-ibmcloud-appid.git)
4. Execute one Bash script
5. Verify the newly created App ID service instance in IBM Cloud

     * Application
     * Scope 
     * Roles
     * Users
     * Login headline
     * Logo
     * Color

### Here are the steps you can follow to execute the example Bash script

#### Step 1: Create a `PayAsYouGo` IBM Cloud Account

Open this [link](https://ibm.biz/BdfXAn) and follow the guided steps.

#### Step 2: Open the [`IBM Cloud Shell`](https://cloud.ibm.com/docs/cloud-shell?topic=cloud-shell-getting-started)

When using the IBM Cloud Shell, no client-side setup is required for this workshop, it comes with all necessary CLIs (command line tools).

Use following link to directly open the `IBM Cloud Shell`.

<https://cloud.ibm.com/shell>

In your browser, login to the [IBM Cloud](https://cloud.ibm.com) Dashboard and open the IBM Cloud Shell from here:

![](images/cns-ce-cloud-shell-01.png)

_Note:_ Your workspace includes 500 MB of temporary storage. This session will close after an hour of inactivity. If you don't have any active sessions for an hour or you reach the 50-hour weekly usage limit, your workspace data is removed.

#### Step 2: Verify the open [`IBM Cloud Shell`](https://cloud.ibm.com/docs/cloud-shell?topic=cloud-shell-getting-started)

Now you are logged on with your IBM Cloud account.

![](images/cns-ce-cloud-shell-02.png)

#### Step 3: Clone the github project into the [`IBM Cloud Shell`](https://cloud.ibm.com/docs/cloud-shell?topic=cloud-shell-getting-started)

```sh
git clone https://github.com/thomassuedbroecker/automated-setup-of-ibmcloud-appid
```

#### Step 4: Navigate to the scripts directory of the GitHub project

```sh
cd automated-setup-of-ibmcloud-appid/scripts
```

#### Step 5: Execute the Bash script `setup-appid.sh`

```sh
bash setup-appid.sh
```

#### Step 6: Verify the created App ID service instance

![](images/result-setup-appid.gif)

### What happens behind the curtain?

Here is some background information what the script does. The [Bash](https://en.wikipedia.org/wiki/Bash_(Unix_shell)) script uses [`cURL`](https://en.wikipedia.org/wiki/CURL), [sed](https://en.wikipedia.org/wiki/Sed) and [grep](https://en.wikipedia.org/wiki/Grep) commands and the [AppID REST API](https://us-south.appid.cloud.ibm.com/swagger-ui/#/). The steps do contain also an example content in [JSON](https://en.wikipedia.org/wiki/JSON) [payload](https://en.wikipedia.org/wiki/Payload) formt, which will be upload. In the GitHub project you find the [JSON files](https://github.com/thomassuedbroecker/automated-setup-of-ibmcloud-appid/tree/master/scripts/appid-configs) I prepared for that example.

Here are some of the configured values:

* Application name: `myexamplefrontend`
* Role name: `tenant_user_access`
* Scope name: `tenant_scope`
* User: `thomas@example.com` with password `thomas4appid`

### Use of the IBM Cloud CLI to create a service instance and a service key

#### Step 1: Configure `region` and `resource group`

For that task it uses the IBM Cloud CLI.

```sh
ibmcloud target -g $RESOURCE_GROUP
ibmcloud target -r $REGION
```

#### Step 2: Creates an App ID service instance

For that task it uses the IBM Cloud CLI using [`ibmcloud resource service-instance-create`](https://cloud.ibm.com/docs/Cloudant?topic=Cloudant-creating-an-ibm-cloudant-instance-on-ibm-cloud-by-using-the-ibm-cloud-cli).

```sh
ibmcloud resource service-instance-create $YOUR_SERVICE_FOR_APPID $APPID_SERVICE_NAME $SERVICE_PLAN $REGION
```

#### Step 3: Create a service key for the AppID service instance

The service key contains needed configuration and access information we need to configure the service.

```sh
ibmcloud resource service-key-create $APPID_SERVICE_KEY_NAME $APPID_SERVICE_KEY_ROLE --instance-name $YOUR_SERVICE_FOR_APPID
```

### Use the App ID REST API using cURL

Configuration of identity providers, application, scope, role and import existing users and more.

#### Step 1: Set identity providers

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

Format to enable Cloud Directory as identity provider.

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

#### Step 2: Create application

```sh
result=$(curl -d @./$ADD_APPLICATION -H "Content-Type: application/json" -H "Authorization: Bearer $OAUTHTOKEN" $MANAGEMENTURL/applications)
```

Format to upload an application

```json
{
    "name": "cns-ce-example",
    "type": "singlepageapp"
}
```

#### Step 3: Add scope

```sh
result=$(curl -d @./$ADD_SCOPE -H "Content-Type: application/json" -X PUT -H "Authorization: Bearer $OAUTHTOKEN" $MANAGEMENTURL/applications/$APPLICATION_CLIENTID/scopes)
``` 

Format to upload the scope.

```json
{
  "scopes": [
    "cns_example_scope"
  ]
}
```

#### Step 4: Add role

```sh
#Create file from template
sed "s+APPLICATIONID+$APPLICATION_CLIENTID+g" ./add-roles-template.json > ./$ADD_ROLE
OAUTHTOKEN=$(ibmcloud iam oauth-tokens | awk '{print $4;}')
#echo $OAUTHTOKEN
result=$(curl -d @./$ADD_ROLE -H "Content-Type: application/json" -X POST -H "Authorization: Bearer $OAUTHTOKEN" $MANAGEMENTURL/roles)
``` 

Format to upload a role.

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

#### Step 5: Import users

```sh
result=$(curl -d @./$USER_IMPORT_FILE -H "Content-Type: application/json" -X POST -H "Authorization: Bearer $OAUTHTOKEN" $MANAGEMENTURL/cloud_directory/import?encryption_secret=$ENCRYPTION_SECRET)
```

Format of an exported user, which will be imported.

```json
{"itemsPerPage":1,"totalResults":1,"users":[{"scimUser":{"originalId":"7cdf7ac3-371f-4b4c-8d0a-81e479ab449b","name":{"givenName":"Thomas","familyName":"Example","formatted":"Thomas Example"},"displayName":"Thomas Example","active":true,"emails":[{"value":"thomas@example.com","primary":true}],"passwordHistory":[{"passwordHash":"L6EEYnQANBPSBF0tDCPDZl4uVD07H3Ur8qIVynB1Ht4Bn4s/x0lA6kvyJxEPr/06m5hi5wdLM45JtYDlT8M0hjVIBI3YpXRR9J4oXZA/Yt/V13yjsUPsXKek6RWdOKWp+wuD5w3Bobh43QbRR3dXFoKUbcLVWQoKLWqvRATMQis=","hashAlgorithm":"PBKDF2WithHmacSHA512"}],"status":"CONFIRMED","passwordExpirationTimestamp":0,"passwordUpdatedTimestamp":0,"mfaContext":{}},"passwordHash":"L6EEYnQANBPSBF0tDCPDZl4uVD07H3Ur8qIVynB1Ht4Bn4s/x0lA6kvyJxEPr/06m5hi5wdLM45JtYDlT8M0hjVIBI3YpXRR9J4oXZA/Yt/V13yjsUPsXKek6RWdOKWp+wuD5w3Bobh43QbRR3dXFoKUbcLVWQoKLWqvRATMQis=","passwordHashAlg":"PBKDF2WithHmacSHA512","profile":{"attributes":{}},"roles":["ce_user_access"]}]}
```

#### Step 6: Add redirect URLs

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

### Summany

The combination of the [AppID REST API](https://us-south.appid.cloud.ibm.com/swagger-ui/#/), [IBM Cloud CLI](https://cloud.ibm.com/docs/cli?topic=cli-getting-started), [`cURL`](https://en.wikipedia.org/wiki/CURL), [Bash](https://en.wikipedia.org/wiki/Bash_(Unix_shell)), [sed](https://en.wikipedia.org/wiki/Sed) and [grep](https://en.wikipedia.org/wiki/Grep) give us all we need to create a full automated way to setup the service instance and service configuration without any user interaction.


