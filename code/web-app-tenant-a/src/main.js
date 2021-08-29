import Vue from 'vue'
import App from './App.vue'
import store from './store'
import router from './router';
import BootstrapVue from 'bootstrap-vue';
import AppID from 'ibmcloud-appid-js';

import 'bootstrap/dist/css/bootstrap.css';
import 'bootstrap-vue/dist/bootstrap-vue.css';

Vue.config.productionTip = false
Vue.config.devtools = true
Vue.use(BootstrapVue);

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
    appid_clientId: window.VUE_APPID_CLIENT_ID,
    appid_discoveryEndpoint: window.VUE_APPID_DISCOVERYENDPOINT,  
    cns: 'http://localhost:8080'
  }
  store.commit("setAPIAndLogin", appid_init);
  console.log("--> log: appid_init", appid_init);

  urls = {
    api: window.VUE_APP_WEPAPI,
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


