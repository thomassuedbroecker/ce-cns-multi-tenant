# Extract tenant and reconfigure OIDC configuration

```java
package com.ibm.webapi;

import javax.enterprise.context.ApplicationScoped;

// Tenant
//import io.quarkus.oidc.TenantResolver;
import io.quarkus.oidc.TenantConfigResolver;
import io.quarkus.oidc.OidcTenantConfig;
import io.vertx.ext.web.RoutingContext;

@ApplicationScoped
public class CustomTenantConfigResolver implements TenantConfigResolver {
   
    @Override
    public OidcTenantConfig resolve(RoutingContext context) {
        System.out.println("-->log: com.ibm.web-api.CustomTenantResolver.resolve : " + context.request().path());
        String path = context.request().path();
        String[] parts = path.split("/");

        if (parts.length == 0) {
            // resolve to default tenant configuration
            return null;
        }

        if ("articlesA".equals(parts[1])) {
            OidcTenantConfig config = new OidcTenantConfig();

            System.out.println("-->log: com.ibm.web-api.CustomTenantResolver.resolve A: " + config.getToken().getIssuer().toString());

            config.setTenantId("tenantA");
            config.setAuthServerUrl("http://localhost:8282/auth/realms/tenantA");
            config.setClientId("backend-service");
            OidcTenantConfig.Credentials credentials = new OidcTenantConfig.Credentials();
            credentials.setSecret("secret");
            config.setCredentials(credentials);

            System.out.println("-->log: com.ibm.web-api.CustomTenantResolver.resolve A: " + config.toString());


            // any other setting support by the quarkus-oidc extension

            return config;
        }

        if ("articlesB".equals(parts[1])) {
            System.out.println("-->log: com.ibm.web-api.CustomTenantResolver.resolve");           
            OidcTenantConfig config = new OidcTenantConfig();
 
            System.out.println("-->log: com.ibm.web-api.CustomTenantResolver.resolve issuer: " + config.getToken().getIssuer().toString());
            
            config.setTenantId("tenantB");
            config.setAuthServerUrl("http://localhost:8282/auth/realms/tenantB");
            config.setClientId("backend-service");
            OidcTenantConfig.Credentials credentials = new OidcTenantConfig.Credentials();
            credentials.setSecret("secret");
            config.setCredentials(credentials);

            System.out.println("-->log: com.ibm.web-api.CustomTenantResolver.resolve B: " + config.toString());

            // any other setting support by the quarkus-oidc extension

            return config;
        }


        return null;
    }
}
```