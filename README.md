# UNDER CONSTRUCTION

### Basic UseCase

#### Short Description 

Get articles displayed based on your email domain, user role and user authentication and authorization.

#### Basic Flow

1. Insert email address
2. Based on the domain of your email address you are routed to the right tenant ( example `blog.de` and `blog.com`)
3. Login to the right realm on the Identity and Access Management system
4. The articles are displayed according to the user role and tenant.

* Example basic flow implementation (local machine)

![](./documentation/images/very-basic-mulit-tenant.gif)

### Technologies

* Keycloak
* Cloudant
* Java
* Quarkus
* Code Engine
* Vue.js
* JavaScript
* Bash

### Architecture

* Basic dependencies (local machine)

![](./documentation/images/very-basic-mulit-tenant-diagram.gif)

The gif shows a basic overview of following sequence:

1. Invoke `web-app-select` on `port 8080` and insert your email to select the domain for the tenant ((blog.de == tenantA) and (blog.com == tenantA))
2. The related webfronted for `blog.de` is invoked, it's `web-app-tenant-a` (`port 8081`) that redirects to the right Keycloak realm (tenant-A) which provides the login and returns the access-token. 

We use that token to access the `web-api` microservice (`port 8083`). Therefor we invoke the `web-api` REST endpoint related to the right tenant (realm), in this case it's tenant-a.

3. The microservice `web-api` uses the the functionalities for multitenancy [provided by Quarkus](https://quarkus.io/guides/security-openid-connect-multitenancy) for the **validation of the access token** at right Keycloak realm and **forwards the given access-token** to the microservice articles, by using the right REST endpoint for the given tenant.

4. The `articles` microservce does the same validation as `web-api` using [Quarkus](https://quarkus.io/guides/security-openid-connect-multitenancy) and uses the right query to provide the needed articles data from the Cloudant database.

* In this example we use:

    1. Three web applications

         * web-app-select (extract domain)
         * web-app-tenant-a (connect to tenant a)
       * web-app-tenant-b (connect to tenant b)

    2. Two microservices

        * web-api (react based on given tenant )
        * articles (react based on given tenant )

    3. One Identity and Access Management system

       * Keycloak with two custom realms

    4. One database service on IBM Cloud

       * Cloudant with one Database       

### Environment

* Mac OS
* VS Code

### Plan

| Task | State | Comments|
| --- | --- | --- |
|Get it working on the local machine | **done** | simplified for the basic Use Case  |
| Deploy it to Code Engine | **open** |   |
| redefine the usecase and technology | **open** |   |
