#!/bin/bash

MINECRAFT_SERVER_JAR=${MINECRAFT_SERVER_JAR:-minecraft_server.jar}
JAVA_ARGS=${JAVA_ARGS:-"JAVA_ARGS-Xms1G -Xmx1G -XX:+UseConcMarkSweepGC"}

if [ ! -f /opt/minecraft-server-jar/${MINECRAFT_SERVER_JAR} ]; then
    echo "The minecraft server file is not found in VOLUME /opt/minecraft-server-jar or"
    echo "env variable MINECRAFT_SERVER_JAR not set."
    echo "MINECRAFT_SERVER_JAR=${MINECRAFT_SERVER_JAR}"
    exit 1
fi

cd /opt/minecraft-server
exec java ${JAVA_ARGS} -jar /opt/minecraft-server-jar/${MINECRAFT_SERVER_JAR}
