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
---

### Use the App ID client SDK in Vue.js

Relevant code in the main.js file. 
The code is structured in :

* Authentication init
* Functions 
* Authentication
* Create vue appication instance

```javascript
import AppID from 'ibmcloud-appid-js';
...
let currentHostname = window.location.hostname; 
let appid_init;
let user_info;
let urls;

/**********************************/
/* Authentication init
/**********************************/

if (currentHostname.indexOf('localhost') > -1) {
  console.log("--> log: option 1");
  appid_init = {
    
    //web-app-tenant-a-single
    appid_clientId: 'b3adeb3b-XXX-40cb-9bc3-dd6f15047195',
    appid_discoveryEndpoint: 'https://us-south.appid.cloud.ibm.com/oauth/v4/a7ec8ce4-3602-42c7-XXX-6f8a9db31935/.well-known/openid-configuration',
    
    cns: 'http://localhost:8080'
  }
  store.commit("setAPIAndLogin", appid_init);
  console.log("--> log: appid_init", appid_init);

  urls = {
    api: 'http://localhost:8083',
  }
  store.commit("setAPI", urls);
  console.log("--> log: urls", urls);
}

let initOptions = {
  clientId: store.state.appid_init.appid_clientId , discoveryEndpoint: store.state.appid_init.appid_discoveryEndpoint
}

/**********************************/
/* Functions 
/**********************************/

async function asyncAppIDInit(appID) {

  var appID_init_Result = await appID.init(initOptions);
  console.log("--> log: appID_init_Result ", appID_init_Result);
  
  try {
    /******************************/
    /* Authentication
    /******************************/
    let tokens = await appID.signin();
    console.log("--> log: tokens ", tokens);   
    user_info = {
      isAuthenticated: true,
      idToken : tokens.idToken,
      accessToken: tokens.accessToken,
      name : tokens.idTokenPayload.name
    }
    store.commit("login", user_info);
    return true;
  } catch (e) {
    console.log("--> log: error ", e);
    return false;
  } 
};

/**********************************/
/* Create vue appication instance
/**********************************/
let appID = new AppID();
let init_messsage = "";
if (!(init_messsage=asyncAppIDInit(appID))) {
  console.log("--> log: init_messsage : " + init_messsage);
  window.location.reload();
} else {
    console.log("--> log: init_messsage : " + init_messsage);
    // Vue application instance
    new Vue({
      store,
      router,
      render: h => h(App)
    }).$mount('#app');
}
```
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

