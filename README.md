Minecraft empty server. You need to provide the server jar.

# Build
`docker build --rm -f "Dockerfile" -t tabinol/empty-server-minecraft:latest .` 

# Exec
`docker run -it -p 25565:25565 -v minecraft-server-jar:/opt/minecraft-server-jar -v minecraft-server:/opt/minecraft-server -e MINECRAFT_SERVER_JAR=spigot-1.14.4.jar -e JAVA_ARGS="-Xms2G -Xmx2G -XX:+UseConcMarkSweepGC" tabinol/empty-server-minecraft`

# Env variables
| Variable             | Description                           | Default                                        |
|----------------------|---------------------------------------|------------------------------------------------|
| MINECRAFT_SERVER_JAR | Name of the minecraft server jar file | minecraft_server.jar                           |
| JAVA_ARGS            | Arguments for java                    | JAVA_ARGS-Xms1G -Xmx1G -XX:+UseConcMarkSweepGC |
| USER_UID             | GID of the minecraft server user      | 1000                                           |
