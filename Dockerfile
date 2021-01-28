ARG JAVA_VERSION_PREFIX=11
ARG JAVA_VERSION_SUFFIX=-jre
ARG SIGTERM_PLUGIN_VERSION=1.0.0

FROM maven:3.6.3-openjdk-${JAVA_VERSION_PREFIX} as builder
ARG JAVA_VERSION_PREFIX
ARG JAVA_VERSION_SUFFIX
ARG SIGTERM_PLUGIN_VERSION

RUN apt-get update && apt-get install -y --no-install-recommends \
    git gcc libc-dev

WORKDIR /sigterm-plugin-build
RUN git clone -b ${SIGTERM_PLUGIN_VERSION} https://github.com/Tabinol/sigterm-minecraft-plugin.git .
RUN mvn package

WORKDIR /su-exec
RUN set -ex
RUN curl -o /su-exec/su-exec.c https://raw.githubusercontent.com/ncopa/su-exec/master/su-exec.c
RUN gcc -Wall /su-exec/su-exec.c -o/su-exec/su-exec

FROM openjdk:${JAVA_VERSION_PREFIX}${JAVA_VERSION_SUFFIX}
ARG SIGTERM_PLUGIN_VERSION
ENV SIGTERM_PLUGIN_VERSION=${SIGTERM_PLUGIN_VERSION}

RUN apt-get update && apt-get install -y \
    netcat-openbsd \
    && rm -rf /var/lib/apt/lists/*
 
COPY --from=builder /su-exec/su-exec /usr/local/bin/su-exec
RUN chmod +x /usr/local/bin/su-exec

RUN mkdir -p /opt/minecraft-server-utils
COPY --from=builder /sigterm-plugin-build/target/sigterm-${SIGTERM_PLUGIN_VERSION}.jar /opt/minecraft-server-utils

ADD entrypoint.sh /opt/bin/entrypoint.sh
RUN chmod +x /opt/bin/entrypoint.sh

VOLUME [ "/opt/minecraft-server-jar", "/opt/minecraft-server" ]
EXPOSE 25565/tcp
ENTRYPOINT ["/opt/bin/entrypoint.sh"]
