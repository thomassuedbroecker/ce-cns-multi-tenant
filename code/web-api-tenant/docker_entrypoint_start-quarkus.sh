#!/bin/bash

export info=$(pwd)

echo "**********************************"
echo "-> Log: Root path: '$info'"
echo "-> Log: Check env variables: '$CNS_ARTICLES_URL_TENANT_A', '$APPID_AUTH_SERVER_URL_TENANT_A' '$APPID_CLIENT_ID_TENANT_A'"

echo "**********************************"
echo "Execute java command "
echo "**********************************"

java -Xmx128m \
     -Xscmaxaot100m \
     -XX:+IdleTuningGcOnIdle \
     -Xtune:virtualized \
     -Xscmx128m \
     -Xshareclasses:cacheDir=/opt/shareclasses \
     -Dquarkus.oidc.auth-server-url=${APPID_AUTH_SERVER_URL_TENANT_A}
     -Dcns.cns.articles-url_tenant_A=${CNS_ARTICLES_URL_TENANT_A} \
     -Dcns.appid.auth-server-url_tenant_A=${APPID_AUTH_SERVER_URL_TENANT_A} \
     -Dcns.appid.client_id_tenant_A=${APPID_CLIENT_ID_TENANT_A} \
     -jar \
     /deployments/quarkus-run.jar
