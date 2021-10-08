# UNDER CONSTRUCTION for APP ID

### Objective

Getting started to implement an example microservices based application using IBM Cloud App ID for authenication and authorization. 

The starting point from the technical and usage perspective is this workshop [`Get started to deploy a Java Microservices application to Code Engine`](https://suedbroecker.net/2021/05/28/new-hands-on-workshop-get-started-to-deploy-a-java-microservices-application-to-code-engine/).

### Basic Use Case

#### Short Description 

Get articles displayed based on your user role and user authentication and authorization.

#### Basic Flow

1. Open the web application
2. Authenticate at AppID
3. The articles are displayed according to the user authorization.

Here an example basic flow implementation at the local machine.

![](images/very-basic-mulit-tenant.gif)

### Architecture

* Basic dependencies (local machine)

![](images/very-basic-mulit-tenant-diagram.gif)

The gif shows a basic overview of following sequence:

2. The `web-app-tenant-a` (`port 8081`) that redirects to the App ID which provides the login and returns the access-token. We use that token to access the `web-api` microservice (`port 8083`). Therefor we invoke the `web-api` REST endpoint.

3. The microservice `web-api` uses the the functionalities for multitenancy [provided by Quarkus `security openID connect multitenancy`](https://quarkus.io/guides/security-openid-connect-multitenancy) to extract the invoked endpoint from the `rootcontext` and set the right configuration for the given App ID tenant. Quarkus also does the **validation of the access token** at App ID and **forwards the given access-token** to the microservice articles.

4. The `articles` microservice does the same validation as `web-api` using [Quarkus](https://quarkus.io/guides/security-openid-connect-multitenancy) and provides data.


* In this example we use:

    1. Three web applications

         * web-app-tenant-a (connect to tenant a)

    2. Two microservices

        * web-api (react based on given tenant)
        * articles (react based on given tenant)

    3. One Identity and Access Management system

        * App ID
  
### Technologies

The example application currently uses following technologies.

* Identity and Access Management

    * [App ID](https://cloud.ibm.com/docs/appid?topic=appid-getting-started&interface=ui)

* Multi Tenancy (not needed but used)
 
    * [Quarkus Security OpenID Connect Multi Tenancy](https://quarkus.io/guides/security-openid-connect-multitenancy) for the Java microservices implementation

* Microservies

    * [Quarkus](https://quarkus.io)
    * Java

* Web frontends:

    * [Vue.js](https://vuejs.org)
    * JavaScript

* Example setup automation

    * Bash