import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    endpoints: {
      api : " "   
    },
    appid_init: {
      appid_clientId: " ",
      appid_discoveryEndpoint: " "
    },
    user: {
      isAuthenticated: false,
      name: "",
      idToken: "",
      accessToken: ""
    }
  },
  mutations: {
    setAPI(state, payload) {
      state.endpoints.api = payload.api;      
    },
    setAPIAndLogin(state, payload) {
      state.appid_init.appid_clientId = payload.appid_clientId;
      state.appid_init.appid_discoveryEndpoint = payload.appid_discoveryEndpoint;
    },
    logout(state) {
      state.user.isAuthenticated = false;
      state.user.name = "";
      state.user.idToken = "";
      state.user.accessToken = "";
    },
    login(state, payload) {
      state.user.isAuthenticated = true;
      state.user.idToken = payload.idToken;
      state.user.accessToken = payload.accessToken;
      state.user.name = payload.name;
    },
    setName(state, payload) {
      state.user.name = payload.name;
    }
  },
  actions: {
  }
})
