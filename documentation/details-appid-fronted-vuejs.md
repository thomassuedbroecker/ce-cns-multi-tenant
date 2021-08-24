# Details for the Vue.js frontend

---
### Create new branch github

* [Informtion on stackoverflow](https://stackoverflow.com/questions/4470523/create-a-branch-in-git-from-another-branch)

---
### Add App ID client SDK

* [App ID client SDK for Single WebPage](https://github.com/ibm-cloud-security/appid-clientsdk-js) using `yarn add - npm:<package>`
* [How to implement await in JavaScript](https://basarat.gitbook.io/typescript/future-javascript/async-await)

```sh
yarn add - npm:ibmcloud-appid-js
```

Relevant code in the main.js file.

```javascript
/**********************************/
/* Functions
/**********************************/

async function asyncAppIDInit(appID) {

  var appID_init_Result = await appID.init({
        clientId: 'b3adeb3b-36fc-40cb-9bc3-dd6f15047195',
        discoveryEndpoint: 'https://us-south.appid.cloud.ibm.com/oauth/v4/a7ec8ce4-3602-42c7-8e88-6f8a9db31935/.well-known/openid-configuration'
  });
  console.log("--> log: appID_init_Result ", appID_init_Result);
  
  try {
    const tokens = await appID.signin();
    console.log("--> log: tokens ", tokens);
  } catch (e) {
    console.log("--> log: tokens ", e);
    return appID_init_Result;
  } 
};

let appID = new AppID();
asyncAppIDInit(appID);
```

---
### Compare App ID and Keycloak

* [Keycloak REST API](https://www.keycloak.org/docs-api/10.0/rest-api/index.html)
* [App ID API documentation](https://cloud.ibm.com/apidocs/app-id/auth)

| Functionality | Keycloak | App ID |
|---|---|---|
| Configuration of User and Role using the API calls | Possible with the Admin API | Not possible for "Cloud Directory" |
| Configurations different roles in differnt tenants | Possible using different realms or different groups  | You need different App ID instances |
| Configartions different roles in differnt tenants | Possible using different realms or different groups  | You need different App ID instances |

---
### Extract URL information

Message:

> Invalid redirect_uri
> The supplied redirect_uri is not registered with this App > ID service instance.
> 
> Registering your redirect_uri with App ID ensures that only authorized clients are allowed to participate in the authorization workflow.
> 
> To register it follow these steps:
> 
> 1. Copy the value of the redirect_uri parameter of this page.
> 
> 2. Open App ID and navigate to
Manage Authentication > Authentication Settings.
> 
> 3. Add the redirect_uri to the list of Web redirect URLs.
> 
> 
> For more information about redirects, see the docs.

https://us-south.appid.cloud.ibm.com/oauth/v4/a7ec8ce4-3602-42c7-8e88-6f8a9db31935/authorization?

* client_id=b3adeb3b-36fc-40cb-9bc3-dd6f15047195 &
* response_type=code&state=NTkxYWVjN2FkYzcyZmU4ZTQzYzg%3D &
* code_challenge=OTdiOTVkNzJkNWIzZmZjZDQwMWU0ZGE5ZmRhNDU2ODQ1ZDNjNTE3NDMzMWIxYTMyZGQ1ZTBjYmE3Zjc3NzUxNA%3D%3D &
* code_challenge_method=S256 &
* redirect_uri=http%3A%2F%2Flocalhost%3A8080 &
* response_mode=web_message&nonce=95c8cdb08ea20590061a&
* scope=openid

