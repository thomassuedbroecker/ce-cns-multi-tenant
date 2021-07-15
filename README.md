# UNDER CONSTRUCTION

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

### Environment

* Mac OS
* VS Code

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

### Plan

| Task | State | Comments|
| --- | --- | --- |
|Get it working on the local machine | **done** | simplified for the basic Use Case  |
| Deploy it to Code Engine | **open** |   |
| redefine the usecase and technology | **open** |   |
