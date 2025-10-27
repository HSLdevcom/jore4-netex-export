FROM maven:3.9.11-eclipse-temurin-24 AS builder

# set up workdir
WORKDIR /build

# download dependencies
COPY ./pom.xml /build
RUN mvn de.qaware.maven:go-offline-maven-plugin:resolve-dependencies

# copy sources
COPY ./src /build/src

# copy generated classes
COPY ./target/generated-sources/jooq /build/target/generated-sources/jooq

# package using "prod" profile
COPY ./profiles/prod /build/profiles/prod
RUN mvn -Pprod -DskipTests=true package spring-boot:repackage

FROM eclipse-temurin:24.0.2_12-jre

# install curl
RUN apt-get update && apt-get install -y curl

# expose server port
EXPOSE 8080

# download script for reading Docker secrets
RUN curl -o /tmp/read-secrets.sh "https://raw.githubusercontent.com/HSLdevcom/jore4-tools/main/docker/read-secrets.sh"

# copy over helper scripts
COPY ./script/build-jdbc-urls.sh /tmp/

# copy compiled jar from builder stage
COPY --from=builder /build/target/*.jar /usr/src/jore4-netex-export/jore4-netex-export.jar

# read Docker secrets into environment variables and run application
CMD /bin/bash -c "source /tmp/read-secrets.sh && source /tmp/build-jdbc-urls.sh && java -jar /usr/src/jore4-netex-export/jore4-netex-export.jar"

HEALTHCHECK --interval=1m --timeout=5s \
  CMD curl --fail http://localhost:8080/actuator/health
