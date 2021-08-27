package com.ibm.webapi;

import org.eclipse.microprofile.rest.client.RestClientBuilder;
import javax.annotation.PostConstruct;
import javax.enterprise.context.ApplicationScoped;
import javax.ws.rs.core.UriBuilder;
import java.net.URI;
import java.util.List;
import org.eclipse.microprofile.config.inject.ConfigProperty;

// OICD
import org.eclipse.microprofile.jwt.JsonWebToken;
import io.quarkus.oidc.IdToken;
import io.quarkus.oidc.RefreshToken;
import javax.inject.Inject;

@ApplicationScoped
public class ArticlesDataAccess {

    @Inject
    @IdToken
    JsonWebToken idToken;

    @Inject
    JsonWebToken accessToken;

    @Inject
    RefreshToken refreshToken;
    
    @ConfigProperty(name = "cns.articles-url_tenant_A") 
    private String articles_url_tenant_A;
    private String used_url;
    private ArticlesService articlesServiceA;

    @PostConstruct
    void initialize() {

        System.out.println("-->log: com.ibm.web-api.ArticlesDataAccess.initialize : " + articles_url_tenant_A );
        // System.out.println("-->log: com.ibm.web-api.ArticlesDataAccess.initialize URL: " + articles_url);
        logJSONWebToken();

        URI apiV1 = null;

        apiV1 = UriBuilder.fromUri(articles_url_tenant_A).build();
        System.out.println("-->log: com.ibm.web-api.ArticlesDataAccess.initialize URI (tenantA) : " + apiV1.toString());
        articlesServiceA = RestClientBuilder.newBuilder()
                .baseUri(apiV1)
                .register(ExceptionMapperArticles.class)
                .build(ArticlesService.class);    
    }

    public List<CoreArticle> getArticles(int amount) throws NoConnectivity {
        try {
            String s=String.valueOf(amount);
            System.out.println("-->log: com.ibm.web-api.ArticlesDataAccess.getArticles count: " + s );
            logJSONWebToken();
            
            String tenant = tenantJSONWebToken();
            System.out.println("-->log: com.ibm.web-api.ArticlesDataAccess.getArticles (tenant): " + tenant );

            if ("tenantA".equals(tenant)){
                System.out.println("-->log: com.ibm.web-api.ArticlesDataAccess.getArticles " + tenant);
                return articlesServiceA.getArticlesFromService(amount);
            } else {
              System.out.println("-->log: com.ibm.web-api.ArticlesDataAccess.getArticles(NO TENANT)");
              return null;
            } 
        } catch (Exception e) {
            System.err.println("-->log: com.ibm.web-api.ArticlesDataAccess.getArticles: Cannot connect to articles service");
            System.out.println("-->log: com.ibm.web-api.ArticlesDataAccess.getArticles URL: " + used_url);
            throw new NoConnectivity(e);
        }
    }

    private void logJSONWebToken(){
        try {
            Object issuer = this.accessToken.getClaim("iss");
            System.out.println("-->log: com.ibm.web-api.ArticlesDataAccess.log issuer: " + issuer.toString());
            return;
        } catch ( Exception e ) {
            System.out.println("-->log: com.ibm.web-api.ArticlesDataAccess.log Exception: " + e.toString());
            return;
        }
    }

    private String tenantJSONWebToken(){
        try {
            Object issuer = this.accessToken.getClaim("iss");
            System.out.println("-->log: com.ibm.web-api.ArticlesDataAccess.log issuer: " + issuer.toString());

            String[] parts = issuer.toString().split("/");
            System.out.println("-->log: com.ibm.web-api.ArticlesDataAccess.log part[5]: " + parts[5]);

            if (parts.length == 0) {
                return "empty";
            }
    
            return parts[5];

        } catch ( Exception e ) {
            System.out.println("-->log: com.ibm.web-api.ArticlesDataAccess.log Exception: " + e.toString());
            return "error";
        }
    }
}

