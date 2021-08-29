# UNDER CONSTRUCTION for APP ID

### Objective

Getting started to implement an example microservices based application for multi tenancy. A basic use case for the example usage needs to be defined. 

The starting point from the technical and usage perspective is this workshop [`Get started to deploy a Java Microservices application to Code Engine`](https://suedbroecker.net/2021/05/28/new-hands-on-workshop-get-started-to-deploy-a-java-microservices-application-to-code-engine/).

#### Planned next steps

The plan will be changed, if needed.

| Task | State | Comments|
| --- | --- | --- |
|Get it working on the local machine | **done** | simplified for the basic Use Case with App ID |
| Deploy it to Code Engine | **open** |   |
| Redefine the use case and technology | **open** |   |
| Plan to implement with redefined use case and technology | **open** |   |

### Basic Use Case

#### Short Description 

Get articles displayed based on your email domain, user role and user authentication and authorization.

#### Basic Flow

1. Open the web application
2. Authenticate at App ID.
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

* Multi Tenancy
 
    * [Quarkus Security OpenID Connect Multi Tenancy](https://quarkus.io/guides/security-openid-connect-multitenancy) for the Java microservices implementation

* Microservies

    * [Quarkus](https://quarkus.io)
    * Java

* Web frontends:

    * [Vue.js](https://vuejs.org)
    * JavaScript

* Example setup automation

    * Bash


### Run the current example locally

#### Prerequisites

##### Environment

* Local

    * OS: Mac OS
    * Visual Studio Code (optional)

    * You need to you have installed on you MacOS:

        * Java: openjdk version "11.0.11"
        * Docker Desktop: "3.4"
        * Apache Maven: "3.8.1"
        * Vue.js: vue/cli "4.5.13"

#### Steps

You should be able to simply run the example locally.

##### Step 1: Clone the project

```sh
git clone https://github.com/thomassuedbroecker/ce-cns-multi-tenant
cd ce-cns-multi-tenant/CE
git fetch --all
git checkout appid-migration-test
```

##### Step 2: Start the example with a bash script

```sh
bash local-start-appid.sh
```

This bash script will start seven terminals:
 
* Web-App tenant A (port 8081)
* Web-API microservice (port 8083)
* Articles microservice (port 8084)

The image below shows the terminal sessions:

![](images/local-example.png)

* one browser sessions
    * Web-App select `http://localhost:8080/` 

##### Step 4: Login to App ID

  Use following:

  - User: `XXX` Password: `XXX`


Verify you App ID configuration.


