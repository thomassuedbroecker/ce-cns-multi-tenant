<template>
  <div>
    <b-container fluid>
       <b-row class="mt-3 center-block">
          <b-form-input v-model="emailaddress" placeholder="Enter your email address "></b-form-input>
       </b-row>
       <b-row class="mt-3 center-block">
          <p></p>
       </b-row>
       <b-row class="mt-3 center-block">
          <b-button style="padding-right: 12px;font-size: 20px;"
                    v-on:click="onSendClicked"
                    kind="tertiary">Send</b-button>
       </b-row>
       <b-modal ref="error" hide-footer title="Wrong email format">
        <div class="d-block text-center">
          <p>Please yerify your email address</p>
          <p>"{{ errormessage }}"</p>
         </div>
        <b-button class="mt-3" variant="outline-danger" block @click="onCloseErrorMessage">OK</b-button>
       </b-modal>
    </b-container>
  </div>
</template>

<script>

export default {
  name: 'Tenant',
  data() {
    return {
        emailaddress: '',
        errormessage: ''
    }
  },
  methods: {
    onSendClicked() {
       let re = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
       if (re.test(String(this.emailaddress).toLowerCase())){
         // Extract tenant
         var domain = this.emailaddress.split("@");
         if ( domain.length < 3) {
           
           // realm tendant A
           var result = domain[1].localeCompare("blog.de");
           console.log("--> log : result ", result);
           if ( 0 == domain[1].localeCompare("blog.de")) {   
              // Invoke tenant
              console.log("--> log : tenant ", domain[1]);
              console.log("--> log : A ", window.VUE_TENANT_A);
              window.open(window.VUE_TENANT_A, "Tenant A");
              this.$forceUpdate();
              this.emailaddress = "";
              this.errormessage = "";         
           }
            
           // realm tendant B
           result = domain[1].localeCompare("blog.com");
           console.log("--> log : result ", result);
           if (0 == domain[1].localeCompare("blog.com")) {
              console.log("--> log : tenant ", domain[1]);
              console.log("--> log : B ", window.VUE_TENANT_B);
              window.open(window.VUE_TENANT_B, "Tenant B"); 
              this.emailaddress = "";
              this.errormessage = "";
              this.$forceUpdate();   
           }
         } else {
           this.$refs['error'].show();
           this.errormessage = this.emailaddress;
           this.emailaddress = "";
           this.$router.push('tenant');
         }
       } else {   
         this.$refs['error'].show();
         this.errormessage = this.emailaddress;
         this.emailaddress = "";
         this.$router.push('tenant');
       }
    },
    onCloseErrorMessage(){
      this.$refs['error'].hide()
    }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
h3 {
  margin: 40px 0 0;
}
ul {
  list-style-type: none;
  padding: 0;
}
li {
  display: inline-block;
  margin: 0 10px;
}
a {
  color: #42b983;
}
</style>
