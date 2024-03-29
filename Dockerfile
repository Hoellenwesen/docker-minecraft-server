FROM eclipse-temurin:17-jre

LABEL maintainer="hoellenwesen"

# Default Minecraft version
ARG MINECRAFT_VERSION=latest

# Set Minecraft version
ENV MINECRAFT_VERSION=$MINECRAFT_VERSION

# Set JVM limits
ENV JAVA_XMS=$JAVA_XMS
ENV JAVA_XMX=$JAVA_XMX

# Get prerequisites
RUN apt update \
    && apt install curl ca-certificates openssl git tar bash tzdata iproute2 jq
    
# Add user
RUN adduser -S -h /home/minecraft minecraft

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
