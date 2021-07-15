package com.ibm.articlesdata;

// JSON-B
import javax.json.bind.annotation.JsonbProperty;

public class Article {

    public Article() {
    }
    @JsonbProperty(nillable = true)
	public String id;
    @JsonbProperty(nillable = true)
	public String title;
    @JsonbProperty(nillable = true)
	public String url;
    @JsonbProperty(nillable = true)
    public String authorName;

}