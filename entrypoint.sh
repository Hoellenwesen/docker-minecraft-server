#!/bin/bash

cd /home/minecraft/

# Check server version
LATEST_VERSION=`curl https://launchermeta.mojang.com/mc/game/version_manifest.json | jq -r '.latest.release'`

echo -e "\e[1mLatest version is $LATEST_VERSION\e[0m"

if [ -z "$MINECRAFT_VERSION" ] || [ "$MINECRAFT_VERSION" == "latest" ]; then
  MANIFEST_URL=$(curl -sSL https://launchermeta.mojang.com/mc/game/version_manifest.json | jq --arg VERSION $LATEST_VERSION -r '.versions | .[] | select(.id== $VERSION )|.url')
  SERVER_VERSION=$LATEST_VERSION
else
  MANIFEST_URL=$(curl -sSL https://launchermeta.mojang.com/mc/game/version_manifest.json | jq --arg VERSION $MINECRAFT_VERSION -r '.versions | .[] | select(.id== $VERSION )|.url')
  SERVER_VERSION=$MINECRAFT_VERSION
fi

# Download server file
DOWNLOAD_URL=$(curl ${MANIFEST_URL} | jq .downloads.server | jq -r '. | .url')

echo -e "\e[1mrunning: curl -o server-${SERVER_VERSION}.jar $DOWNLOAD_URL\e[0m"
curl -o server-${SERVER_VERSION}.jar $DOWNLOAD_URL

echo -e "\e[1mInstall Complete, version: $SERVER_VERSION\e[0m"

# Start minecraft server
sed -i 's/eula=false/eula=true/' eula.txt
exec java -Xmx${JAVA_XMX} -Xms${JAVA_XMS} -jar server-${SERVER_VERSION}.jar nogui