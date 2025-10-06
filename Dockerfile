FROM maven:3.9-eclipse-temurin-21 AS builder

# set up workdir
WORKDIR /build

# download dependencies
COPY ./pom.xml /build
RUN mvn de.qaware.maven:go-offline-maven-plugin:resolve-dependencies

# copy sources
COPY ./src /build/src

RUN mvn -DskipTests=true clean package spring-boot:repackage

FROM eclipse-temurin:21.0.8_9-jre

# expose server port
EXPOSE 8080

# download script for reading Docker secrets
RUN curl -o /tmp/read-secrets.sh "https://raw.githubusercontent.com/HSLdevcom/jore4-tools/main/docker/read-secrets.sh"

# copy compiled jar from builder stage
COPY --from=builder /build/target/*.jar /usr/src/jore4-netex-export/jore4-netex-export.jar

# read Docker secrets into environment variables and run application
CMD /bin/bash -c "source /tmp/read-secrets.sh && java -jar /usr/src/jore4-netex-export/jore4-netex-export.jar"

HEALTHCHECK --interval=1m --timeout=5s \
  CMD curl --fail http://localhost:8080/actuator/health
