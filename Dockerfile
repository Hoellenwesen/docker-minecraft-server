FROM eclipse-temurin:18-jre-alpine

LABEL maintainer="hoellenwesen"

# Default Minecraft version
ARG MINECRAFT_VERSION=latest

# Set Minecraft version
ENV MINECRAFT_VERSION=$MINECRAFT_VERSION

# Set JVM limits
ENV JAVA_XMS=$JAVA_XMS
ENV JAVA_XMX=$JAVA_XMX

# Get prerequisites
RUN apk update --no-cache \
    && apk add --no-cache curl ca-certificates openssl git tar bash tzdata iproute2 jq \
    && adduser --disabled-login --home /home/minecraft minecraft

USER minecraft
WORKDIR /home/minecraft

# Copy files
COPY eula.txt /
COPY server.properties /
COPY entrypoint.sh /entrypoint.sh

# Expose Minecraft port
EXPOSE 25565/tcp

# Run Minecraft service
CMD ["/bin/bash", "/entrypoint.sh"]
