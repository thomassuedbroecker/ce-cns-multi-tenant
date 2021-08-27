package com.ibm.webapi;

// LIST
import java.util.List;
import java.util.stream.Collectors;

// REST
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

// OIDC
//import javax.annotation.security.RolesAllowed;
import javax.inject.Inject;
import org.eclipse.microprofile.jwt.JsonWebToken;
import io.quarkus.oidc.IdToken;
//import io.quarkus.oidc.RefreshToken;

import org.jboss.resteasy.annotations.cache.NoCache;

@Path("/")
public class ArticleResource {

    @Inject
    @IdToken
    JsonWebToken idToken;

    @Inject
    JsonWebToken accessToken;

    @Inject
    ArticlesDataAccess articlesDataAccess;

    @GET
    @Path("/articlesA")
    @Produces(MediaType.APPLICATION_JSON)
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

    private List<Article> createArticleList(List<CoreArticle> coreArticles) {
        return coreArticles.stream()
                .map(coreArticle -> {
                    Article article = new Article();
                    article.id = coreArticle.id;
                    article.title = coreArticle.title;
                    article.url = coreArticle.url;
                    article.authorName = coreArticle.author;
                    article.authorBlog = "";
                    article.authorTwitter = "";
                    return article;
                }).collect(Collectors.toList());
    }
    
}