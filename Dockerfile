# Tomcat debian-slim image (any official image would do)
FROM ebguilbert/tomcat-slim:9

LABEL maintainer="Edwin Guilbert"

# ENV variables for Magnolia
ENV MGNL_VERSION 6.2
ENV MGNL_APP_DIR /opt/magnolia
ENV MGNL_REPOSITORIES_DIR ${MGNL_APP_DIR}/repositories
ENV MGNL_LOGS_DIR ${MGNL_APP_DIR}/logs
ENV MGNL_RESOURCES_DIR ${MGNL_APP_DIR}/light-modules
ENV JDBC_VERSION=postgresql-42.2.12

# ARGS
ARG MGNL_AUTHOR=true
ARG MGNL_WAR_PATH=docker-bundle/docker-bundle-webapp/target/docker-bundle-webapp-6.2.war
ARG MGNL_HEAP=2048M
ARG MGNL_ENV=tomcat/setenv.sh
ARG JDBC_URL=https://jdbc.postgresql.org/download

# JVM PARAMS
ENV CATALINA_OPTS -Xms64M -Xmx${MGNL_HEAP} -Djava.awt.headless=true \
    -Dmagnolia.bootstrap.authorInstance=${MGNL_AUTHOR} \
    -Dmagnolia.repositories.home=${MGNL_REPOSITORIES_DIR} \
    -Dmagnolia.author.key.location=${MGNL_APP_DIR}/magnolia-activation-keypair.properties \
    -Dmagnolia.logs.dir=${MGNL_LOGS_DIR} \
    -Dmagnolia.resources.dir=${MGNL_RESOURCES_DIR} \
    -Dmagnolia.update.auto=true

# VOLUME for Magnolia
VOLUME [ "${MGNL_APP_DIR}" ]

# JDBC lib
RUN wget -q ${JDBC_URL}/${JDBC_VERSION}.jar -O $CATALINA_HOME/lib/${JDBC_VERSION}.jar

# Database runtime config
# - DB_ADDRESS
# - DB_PORT
# - DB_SCHEMA
# - DB_USERNAME
# - DB_PASSWORD
COPY ${MGNL_ENV} $CATALINA_HOME/bin/setenv.sh

# MGNL war
COPY ${MGNL_WAR_PATH} ${DEPLOYMENT_DIR}/ROOT.war
