<template>
  <div id="app">
    <b-navbar
      toggleable="lg"
      type="dark"
      variant="info"
      style="background-color: #1675fd !important;"
    >
      <b-navbar-brand>Cloud Native Starter (Tenant A)</b-navbar-brand>

      <b-navbar-nav class="ml-auto">
        <b-navbar-nav v-if="isAuthenticated == false">
          <b-nav-item v-on:click="onLoginClicked">Refresh browser</b-nav-item>
        </b-navbar-nav>
        <b-nav-item-dropdown right v-if="isAuthenticated == true">
          <template slot="button-content">{{ getUserName() }}</template>
          <b-dropdown-item v-on:click="onLogoutClicked">Logout</b-dropdown-item>          
        </b-nav-item-dropdown>
        <b-nav-item-dropdown right v-if="isAuthenticated == true">
          <template slot="button-content">Load articels</template>
          <b-dropdown-item v-on:click="onLoadArticlesClicked">Load articels</b-dropdown-item>          
        </b-nav-item-dropdown>
      </b-navbar-nav>
    </b-navbar>
    <div style="margin-left:20px;margin-right:20px" >
      <router-view/>
      <b-spinner v-if="loading == true" label="Loading ..."/>
      <div style="margin-top:30px" v-if="manageResponse != ''">
        <div>Response from 'Manage Application' ({{ webApiUrl }}):</div>
        <div style="margin-top:10px">{{ manageResponse }}</div>
      </div>
    </div>
  </div>
</template>

<script>
import Home from "./components/Home.vue";
import axios from "axios";

export default {
  name: "app",
  components: {
    Home
  },
  computed: {
    isAuthenticated() {
      return this.$store.state.user.isAuthenticated;
    }
  },
  data() {
    return {
      webApiUrl: this.$store.state.endpoints.api + "manage",
      loading: false,
      manageResponse: ""
    };
  },
  methods: {
    
    onLoadArticlesClicked () {
      let auth = btoa(window.VUE_APPID_CLIENT_ID_BACKEND + ":" + window.VUE_APPID_SECRET_BACKEND);
      const axiosService = axios.create({
        timeout: 30000,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Basic"  + auth
        }
      });
      let that = this;
      let appid_auth_server="https://us-south.appid.cloud.ibm.com/oauth/v4/a7ec8ce4-3602-42c7-8e88-6f8a9db31935/token";
      console.log("--> log: try backend : " + appid_auth_server);
      axiosService
        .post(this.appid_auth_server)
        .then(function(response) {
          that.articles = response.data;
          console.log("--> log: readArticles data : " + that.articles);
          that.loading = false;
          that.error = "";
        })
        .catch(function(error) {
          console.log("--> log: readArticles error: " + error);
          that.loading = false;
          that.error = error;
        });
    },
    onLoginClicked() {
      window.location = this.$store.state.endpoints.login;
    },    
    onLogoutClicked() {
      let payloadRefreshedTokens = {
              idToken: "",
              accessToken: ""
      }
      this.$store.commit("login", payloadRefreshedTokens);
      this.$store.commit("logout");
    },
    getUserName() {
      return this.$store.state.user.name;
    }
  }
};
</script>

<style>
.navbar-dark .navbar-nav .nav-link {
  color: #fff !important;
}
</style>
