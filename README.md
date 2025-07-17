# MyDockerApps

This project allows starting or stopping Docker containers for various applications (Joplin, Nextcloud, Zoneminder), all relying on the same Traefik container project. 

A script named services.sh enables starting or stopping these different containers by application.

```
./services.sh {joplin|nextcloud|zm} {up|down}
```

To start or stop everything:

```
docker compose up -d
docker compose down

```