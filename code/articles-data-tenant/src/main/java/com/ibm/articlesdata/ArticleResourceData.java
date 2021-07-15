package com.ibm.articlesdata;

import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.Set;
import javax.annotation.PostConstruct;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

// Security
import org.jboss.resteasy.annotations.cache.NoCache;
import javax.annotation.security.RolesAllowed;

// Token
import org.eclipse.microprofile.jwt.JsonWebToken;
import io.quarkus.oidc.IdToken;
import io.quarkus.oidc.RefreshToken;
import javax.inject.Inject;

// Cloudant database
import java.net.URL;
import org.eclipse.microprofile.config.inject.ConfigProperty;
import java.net.MalformedURLException;

// Cloudant database IBM sdk
import com.ibm.cloud.sdk.core.security.BasicAuthenticator;
import com.ibm.cloud.cloudant.v1.Cloudant;
import com.ibm.cloud.cloudant.v1.model.PostSearchOptions;
import com.ibm.cloud.cloudant.v1.model.SearchResult;
import java.util.List;
import java.util.ArrayList;

// JSON-B
import javax.json.bind.Jsonb;
import javax.json.bind.JsonbBuilder;

// JSON
import javax.json.Json;
import javax.json.JsonObject;
import javax.json.JsonArray;
import javax.json.JsonReader;
// Need to the string input
import java.io.StringReader;  

@Path("/")
public class ArticleResourceData {

    @Inject
    @IdToken
    JsonWebToken idToken;
    @Inject
    JsonWebToken accessToken;
    @Inject
    RefreshToken refreshToken;
    
    private Set<Article> articles = Collections.newSetFromMap(Collections.synchronizedMap(new LinkedHashMap<>()));

    // Tenant
    @ConfigProperty(name = "cns.tenant_A")
    private String tenant_A;
    @ConfigProperty(name = "cns.tenant_B")
    private String tenant_B;
    
    // Cloudant
    @ConfigProperty(name = "cloudant.url")
    private String url;
    @ConfigProperty(name = "cloudant.username")
    private String username;
    @ConfigProperty(name = "cloudant.password")
    private String password;
    @ConfigProperty(name = "cloudant.database")
    private String database;

    // Articles DB
    @ConfigProperty(name = "articlesDB.design")
    private String design;
    @ConfigProperty(name = "articlesDB.index")
    private String index;
    @ConfigProperty(name = "articlesDB.queryA")
    private String queryA;
    @ConfigProperty(name = "articlesDB.queryB")
    private String queryB;

    @GET
    @Path("/articlesA")
    @Produces(MediaType.APPLICATION_JSON)
    //@Authenticated
    @RolesAllowed("user")
    @NoCache
    public Set<Article> getArticlesA() {
        System.out.println("-->log: com.ibm.articles.ArticlesResource.getArticlesA");
        Object issuer = this.accessToken.getClaim("iss");
        System.out.println("-->log: com.ibm.articles.ArticlesResource.getArticles issuer A: " + issuer.toString());
        System.out.println("-->log: com.ibm.articles.ArticlesResource.getArticles articles A: " + articles.toArray().toString());
        //getCloudantData();
        return articles;
    }

    @GET
    @Path("/articlesB")
    @Produces(MediaType.APPLICATION_JSON)
    //@Authenticated
    @RolesAllowed("user")
    @NoCache
    public Set<Article> getArticlesB() {
        System.out.println("-->log: com.ibm.articles.ArticlesResource.getArticlesB");
        Object issuer = this.accessToken.getClaim("iss");
        System.out.println("-->log: com.ibm.articles.ArticlesResource.getArticles issuer B: " + issuer.toString());
        System.out.println("-->log: com.ibm.articles.ArticlesResource.getArticles articles B: " + articles.toArray().toString());
        return articles;
    }

    @PostConstruct
    void addArticles() {
        System.out.println("-->log: com.ibm.articles.ArticleResource.addArticles");
        getCloudantData();
    }

    private void addArticle(String title, String url, String author) {
        Article article = new Article();
        article.title = title;
        article.url = url;
        article.authorName = author;
        articles.add(article);
    }

    private void getCloudantData() {
        System.out.println("-->log: com.ibm.articles.ArticleResource.getCloudantData");
        
        // 1. Connect to IBM Cloudant service =================================
        BasicAuthenticator authenticator = new BasicAuthenticator(username, password);
        Cloudant client = new Cloudant(Cloudant.DEFAULT_SERVICE_NAME, authenticator);
        client.setServiceUrl(url);

        // 2. Select tenant  =================================================
        String query="";
        String tenant =  tenantJSONWebToken();
        System.out.println("-->log: com.ibm.articles.ArticleResourceData.getCloudantData tenant: " + tenant);
        
        if ("tenantA".equals(tenant)){
            query = queryA;
        } 
        
        if ("tenantB".equals(tenant)){
            query = queryB;
        }


        // 3. Get articles query in database =================================
        PostSearchOptions searchOptions = new PostSearchOptions.Builder()
                                                                .db(database)
                                                                .ddoc(design)
                                                                .index(index)
                                                                .query(query)
                                                                .build();

        SearchResult search_response = client.postSearch(searchOptions).execute()
                                                                       .getResult();
        System.out.println("-->log: com.ibm.articles.ArticleResourceData.getCloudantData search_response: " + search_response);
        
        // 4. Extract articles from Cloudant response =========================
        JsonReader jsonReader = Json.createReader(new StringReader(search_response.toString()));
        JsonObject object = jsonReader.readObject();
        jsonReader.close();
        JsonArray rows = object.getJsonArray("rows");
        int total_rows = object.getInt("total_rows");
        
        if (total_rows > 0 ) {
            for (int i = 0; i < total_rows; i++) {
                System.out.println("-->log: com.ibm.articles.ArticleResource.getCloudantData rows: " + rows);
                JsonObject row_object = rows.getJsonObject(i);
                System.out.println("-->log: com.ibm.articles.ArticleResource.getCloudantData row_object: " + row_object);
                JsonObject fields = row_object.getJsonObject("fields");
                System.out.println("-->log: com.ibm.articles.ArticleResource.getCloudantData fields: " + fields);
                String url = fields.getString("url");
                String authorName = fields.getString("authorName");
                String title = fields.getString("title");
                System.out.println("-->log: com.ibm.articles.ArticleResource.getCloudantData Author : " + authorName + " Title: " + " url: " + url);
                addArticle(title, url, title);
            }
        }
    }

    private String tenantJSONWebToken(){
        try {
            Object issuer = this.accessToken.getClaim("iss");
            System.out.println("-->log: com.ibm.articles.ArticlesResourceData.tenantJSONWebToken issuer: " + issuer.toString());

            String[] parts = issuer.toString().split("/");
            System.out.println("-->log: com.ibm.articles.ArticlesResourceData.log part[5]: " + parts[5]);

            if (parts.length == 0) {
                return "empty";
            }
    
            if ("tenantA".equals(parts[5])) {
                return "tenantA";
            }

            if ("tenantB".equals(parts[5])) {
                return "tenantB";
            }
    
            return "tenant not known";

        } catch ( Exception e ) {
            System.out.println("-->log: com.ibm.articles.ArticlesResourceData.log Exception: " + e.toString());
            return "error";
        }
    }
}