# Extract tenant and reconfigure OIDC configuration

Simply implementation for the web-api service.

1. Provide  REST endpoint for each tenant
2. Extract inside the invoked endpoint the JWT access-token and set the right configuration for the given tenant, that means in this case the Keycloak realm.
3. Based on the known tenant invoke the right endpoint of the articles service.
    1. Create REST client for each tenant
    2. Invoke the right client


### Provide  REST endpoint for each tenant

Relevant code in [ArticleResource.java](https://github.com/thomassuedbroecker/ce-cns-multi-tenant/blob/master/code/web-api-tenant/src/main/java/com/ibm/webapi/ArticleResource.java) of the web-api service.

```java
   @GET
    @Path("/articlesA")
    @Produces(MediaType.APPLICATION_JSON)
    //@Authenticated
    @RolesAllowed("user")
    @NoCache
    public List<Article> getArticlesA() {
        try {
            List<CoreArticle> coreArticles = articlesDataAccess.getArticles(5);
            System.out.println("-->log: com.ibm.webapi.ArticleResource.getArticles -> articlesDataAccess.getArticles");
            return createArticleList(coreArticles);
        } catch (NoConnectivity e) {
            System.err.println("-->log: com.ibm.webapi.ArticleResource.getArticles: Cannot connect to articles service");
            throw new NoDataAccess(e);
        }
    }

    @GET
    @Path("/articlesB")
    @Produces(MediaType.APPLICATION_JSON)
    //@Authenticated
    @RolesAllowed("user")
    @NoCache
    public List<Article> getArticlesB() {
        try {
            List<CoreArticle> coreArticles = articlesDataAccess.getArticles(5);
            System.out.println("-->log: com.ibm.webapi.ArticleResource.getArticles -> articlesDataAccess.getArticles");
            return createArticleList(coreArticles);
        } catch (NoConnectivity e) {
            System.err.println("-->log: com.ibm.webapi.ArticleResource.getArticles: Cannot connect to articles service");
            throw new NoDataAccess(e);
        }
    }
```

###  Extract JWT access-token and set the right configuration

Extract inside the invoked endpoint the JWT access-token and set the right configuration for the given tenant, that means in this case the Keycloak realm.

Relevant code in [CustomTenantConfigResolver.java](https://github.com/thomassuedbroecker/ce-cns-multi-tenant/blob/master/code/web-api-tenant/src/main/java/com/ibm/webapi/CustomTenantConfigResolver.java) of the web-api service.

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

### Based on the known tenant invoke the right endpoint of the articles service


#### Create REST client for each tenant

Relevant code in [ArticlesDataAccess.java](https://github.com/thomassuedbroecker/ce-cns-multi-tenant/blob/master/code/web-api-tenant/src/main/java/com/ibm/webapi/ArticlesDataAccess.java) of the web-api service.

```java
URI apiV1 = null;

        apiV1 = UriBuilder.fromUri(articles_url_tenant_A).build();
        System.out.println("-->log: com.ibm.web-api.ArticlesDataAccess.initialize URI (tenantA) : " + apiV1.toString());
        articlesServiceA = RestClientBuilder.newBuilder()
                .baseUri(apiV1)
                .register(ExceptionMapperArticles.class)
                .build(ArticlesService.class);
                
        apiV1 = UriBuilder.fromUri(articles_url_tenant_B).build();
        System.out.println("-->log: com.ibm.web-api.ArticlesDataAccess.initialize URI (tenantB) : " + apiV1.toString());
        articlesServiceB = RestClientBuilder.newBuilder()
                .baseUri(apiV1)
                .register(ExceptionMapperArticles.class)
                .build(ArticlesService.class);     
```

#### Invoke the right client

Relevant code in [ArticlesDataAccess.java](https://github.com/thomassuedbroecker/ce-cns-multi-tenant/blob/master/code/web-api-tenant/src/main/java/com/ibm/webapi/ArticlesDataAccess.java) of the web-api service.

```java
String tenant = tenantJSONWebToken();
            System.out.println("-->log: com.ibm.web-api.ArticlesDataAccess.getArticles (tenant): " + tenant );

            if ("tenantA".equals(tenant)){
                System.out.println("-->log: com.ibm.web-api.ArticlesDataAccess.getArticles " + tenant);
                return articlesServiceA.getArticlesFromService(amount);
            }
    
            if ("tenantB".equals(tenant)){
                System.out.println("-->log: com.ibm.web-api.ArticlesDataAccess.getArticles " + tenant);
                return articlesServiceB.getArticlesFromService(amount);
            } else {
              System.out.println("-->log: com.ibm.web-api.ArticlesDataAccess.getArticles(NO TENANT)");
              return null;
            } 
```