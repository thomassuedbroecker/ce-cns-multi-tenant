# Vue.js

Extract email domain in component [Tenant.vue](https://github.com/thomassuedbroecker/ce-cns-multi-tenant/blob/master/code/web-app-select/src/components/Tenant.vue) of the `web-app select`.

* Simple steps:
    
    1. Use of regular expression
    2. Lower all cases
    3. Split string
    4. Verify result
    5. Invoke the right `web-app` for the given tenant

Relevant code in [Tenant.vue](https://github.com/thomassuedbroecker/ce-cns-multi-tenant/blob/master/code/web-app-select/src/components/Tenant.vue).

```javascript
...
       let re = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
       if (re.test(String(this.emailaddress).toLowerCase())){
         // Extract tenant
         var domain = this.emailaddress.split("@");
         if ( domain.length < 3) {
           
           // realm tendant A
           var result = domain[1].localeCompare("blog.de");
           console.log("--> log : result ", result);
           if ( 0 == domain[1].localeCompare("blog.de")) {   
              // Invoke tenant web-app
              console.log("--> log : tenant ", domain[1]);
              console.log("--> log : A ", window.VUE_TENANT_A);
              window.open(window.VUE_TENANT_A, "Tenant A");
              this.$forceUpdate();
              this.emailaddress = "";
              this.errormessage = ""; 
...    
```
