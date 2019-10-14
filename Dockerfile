FROM openjdk:8-jre

ENV SIGTERM_PLUGIN_VERSION=1.0.0

RUN useradd -ms /bin/bash minecraft
RUN mkdir -p /opt/minecraft-server && chown -R minecraft:minecraft /opt/minecraft-server

RUN mkdir -p /opt/minecraft-server-utils && cd /opt/minecraft-server-utils && wget https://bitbucket.org/Tabinol/sigterm/downloads/sigterm-${SIGTERM_PLUGIN_VERSION}.jar

ADD entrypoint.sh /opt/bin/entrypoint.sh
RUN chmod +x /opt/bin/entrypoint.sh

VOLUME [ "/opt/minecraft-server-jar", "/opt/minecraft-server" ]
EXPOSE 25565/tcp
USER minecraft
ENTRYPOINT ["/opt/bin/entrypoint.sh"]