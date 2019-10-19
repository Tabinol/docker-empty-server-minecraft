Minecraft empty server. You need to provide the server jar.

# Build
`docker build --rm -f "Dockerfile" -t tabinol/empty-server-minecraft:latest .`

# Exec
`docker run -it -p 25565:25565 -v minecraft-server-jar:/opt/minecraft-server-jar -v minecraft-server:/opt/minecraft-server -e MINECRAFT_SERVER_JAR=spigot-1.14.4.jar -e JAVA_ARGS="-Xms2G -Xmx2G -XX:+UseConcMarkSweepGC" tabinol/empty-server-minecraft`

# Shutdown
This image installs SIGTERM Minecraft plugin for gracefull shutdown when we do a _docker stop_. If your server
takes more than 10 seconds to stop, use /docker stop/ command with _-t TIME_IN_SECOND_ option.
`docker stop -t 60 minecraftserv` 

# Env variables
| Variable             | Description                           | Default                                        |
|----------------------|---------------------------------------|------------------------------------------------|
| MINECRAFT_SERVER_JAR | Name of the minecraft server jar file | minecraft_server.jar                           |
| JAVA_ARGS            | Arguments for java                    | JAVA_ARGS-Xms1G -Xmx1G -XX:+UseConcMarkSweepGC |
| USER_UID             | GID of the minecraft server user      | 1000                                           |
