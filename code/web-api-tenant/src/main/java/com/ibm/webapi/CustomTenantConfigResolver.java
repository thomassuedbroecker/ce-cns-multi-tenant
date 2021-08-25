package com.ibm.webapi;

import javax.enterprise.context.ApplicationScoped;

// Tenant
//import io.quarkus.oidc.TenantResolver;
import io.quarkus.oidc.TenantConfigResolver;
import io.quarkus.oidc.OidcTenantConfig;
import io.vertx.ext.web.RoutingContext;

// ConfigProperties
import org.eclipse.microprofile.config.inject.ConfigProperty;

@ApplicationScoped
public class CustomTenantConfigResolver implements TenantConfigResolver {
    
    @ConfigProperty(name = "appid.auth-server-url_tenant_A") 
    private String auth_server_url_tenant_A;
    @ConfigProperty(name = "appid.client_id_tenant_A") 
    private String client_id_tenant_A;
    @ConfigProperty(name = "appid.secret_tenant_A") 
    private String secret_tenant_A;

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
            config.setAuthServerUrl(auth_server_url_tenant_A);
            config.setClientId(client_id_tenant_A);
            OidcTenantConfig.Credentials credentials = new OidcTenantConfig.Credentials();
            credentials.setSecret(secret_tenant_A);
            config.setCredentials(credentials);

            System.out.println("-->log: com.ibm.web-api.CustomTenantResolver.resolve A: " + config.toString());

            // any other setting support by the quarkus-oidc extension

            return config;
        }

        if ("articlesB".equals(parts[1])) {
            System.out.println("-->log: com.ibm.web-api.CustomTenantResolver.resolve tenant B: ");           
            OidcTenantConfig config = new OidcTenantConfig();
 
            System.out.println("-->log: com.ibm.web-api.CustomTenantResolver.resolve issuer B : " + config.getToken().getIssuer().toString());
            
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
