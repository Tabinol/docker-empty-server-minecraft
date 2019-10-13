FROM openjdk:8-jre

RUN useradd -ms /bin/bash minecraft
RUN mkdir -p /opt/minecraft-server && chown -R minecraft:minecraft /opt/minecraft-server

ADD entrypoint.sh /opt/bin/entrypoint.sh
RUN chmod +x /opt/bin/entrypoint.sh

VOLUME [ "/opt/minecraft-server-jar", "/opt/minecraft-server" ]
EXPOSE 25565/tcp
USER minecraft
ENTRYPOINT ["/opt/bin/entrypoint.sh"]