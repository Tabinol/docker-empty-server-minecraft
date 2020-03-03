#!/bin/bash

# Env variables
MINECRAFT_SERVER_JAR=${MINECRAFT_SERVER_JAR:-minecraft_server.jar}
JAVA_ARGS=${JAVA_ARGS:-"JAVA_ARGS-Xms1G -Xmx1G -XX:+UseConcMarkSweepGC"}
USER_UID=${USER_UID:-1000}
MYSQL_WAITFOR=${MYSQL_WAIT:false}
MYSQL_HOST=${MYSQL_HOST:localhost}
MYSQL_PORT=${MYSQL_PORT:3306}

# Create user if not exist
id -u minecraft &>/dev/null || ( useradd --create-home --shell /bin/bash --uid ${USER_UID} minecraft && mkdir -p /opt/minecraft-server/plugins && chown -R minecraft:minecraft /opt/minecraft-server )

# Check for Minecraft jar file
if [ ! -f /opt/minecraft-server-jar/${MINECRAFT_SERVER_JAR} ]; then
    echo "The minecraft server file is not found in VOLUME /opt/minecraft-server-jar or"
    echo "env variable MINECRAFT_SERVER_JAR not set."
    echo "MINECRAFT_SERVER_JAR=${MINECRAFT_SERVER_JAR}"
    exit 1
fi

# Create plugins directory and add the sigterm plugin
if [ ! -f /opt/minecraft-server/plugins/sigterm-${SIGTERM_PLUGIN_VERSION}.jar ]; then
    echo "Copying sigterm-${SIGTERM_PLUGIN_VERSION}.jar"
    rm -f /opt/minecraft-server/plugins/sigterm-*.jar
    cp /opt/minecraft-server-utils/sigterm-${SIGTERM_PLUGIN_VERSION}.jar /opt/minecraft-server/plugins/
    chown minecraft:minecraft /opt/minecraft-server-utils/sigterm-${SIGTERM_PLUGIN_VERSION}.jar
fi

# Waiting for mySQL if needed
if [ "$MYSQL_WAITFOR" = "true" ]; then
    until nc -z -v -w30 ${MYSQL_HOST} ${MYSQL_PORT}
    do
        echo "Waiting for database..."
        sleep 1
    done
fi

cd /opt/minecraft-server
# exec with su-exec or SIGTERM will be ignored
exec su-exec minecraft java ${JAVA_ARGS} -jar /opt/minecraft-server-jar/${MINECRAFT_SERVER_JAR}
