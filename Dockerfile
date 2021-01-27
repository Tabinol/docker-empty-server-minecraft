FROM openjdk:11-jre as builder
WORKDIR /su-exec
RUN set -ex
RUN curl -o /su-exec/su-exec.c https://raw.githubusercontent.com/ncopa/su-exec/master/su-exec.c
RUN apt-get update && apt-get install -y --no-install-recommends gcc libc-dev
RUN gcc -Wall /su-exec/su-exec.c -o/su-exec/su-exec

FROM openjdk:11-jre

ENV SIGTERM_PLUGIN_VERSION=1.0.0

RUN apt-get update && apt-get install -y \
    netcat-openbsd \
    && rm -rf /var/lib/apt/lists/*
 
COPY --from=builder /su-exec/su-exec /usr/local/bin/su-exec
RUN chmod +x /usr/local/bin/su-exec

RUN mkdir -p /opt/minecraft-server-utils \
    && cd /opt/minecraft-server-utils \
    && wget https://bitbucket.org/Tabinol/sigterm/downloads/sigterm-${SIGTERM_PLUGIN_VERSION}.jar

ADD entrypoint.sh /opt/bin/entrypoint.sh
RUN chmod +x /opt/bin/entrypoint.sh

VOLUME [ "/opt/minecraft-server-jar", "/opt/minecraft-server" ]
EXPOSE 25565/tcp
ENTRYPOINT ["/opt/bin/entrypoint.sh"]
