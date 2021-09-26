##############################
#           BUILD
##############################
FROM docker.io/adoptopenjdk/maven-openjdk11 as BUILD
COPY src /usr/src/app/src
COPY pom.xml /usr/src/app
WORKDIR /usr/src/app
RUN mvn package

##############################
#           PRODUCTION
##############################
#FROM adoptopenjdk/openjdk11-openj9:ubi-minimal
#FROM "docker.io/adoptopenjdk/openjdk11-openj9"
FROM docker.io/adoptopenjdk:openj9

ENV JAVA_OPTIONS="-Dquarkus.http.host=0.0.0.0 -Djava.util.logging.manager=org.jboss.logmanager.LogManager"
ENV AB_ENABLED=jmx_exporter

RUN mkdir /opt/shareclasses

# OpenShift permissions:
RUN chmod a+rwx -R /opt/shareclasses
RUN mkdir /opt/app

COPY --from=BUILD --chown=1001 /usr/src/app/target/quarkus-app/lib/ /deployments/lib/
COPY --from=BUILD --chown=1001 /usr/src/app/target/quarkus-app/*.jar /deployments/
COPY --from=BUILD --chown=1001 /usr/src/app/target/quarkus-app/app/ /deployments/app/
COPY --from=BUILD --chown=1001 /usr/src/app/target/quarkus-app/quarkus/ /deployments/quarkus/

# Environment variables
COPY ./docker_entrypoint_start-quarkus.sh ./docker_entrypoint_start-quarkus.sh
RUN chmod 777 docker_entrypoint_start-quarkus.sh 
# **********
# Local
#EXPOSE 8083
# **********
# Code Engie
EXPOSE 8080

CMD ["/bin/sh","docker_entrypoint_start-quarkus.sh"]