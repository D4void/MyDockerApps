# MyDockerApps

This project allows starting or stopping Docker containers for my various applications (Joplin, Nextcloud, Zoneminder), all relying on the same Traefik container project.  (https://github.com/D4void/MyTraefik)
* https://github.com/D4void/MyNextCloud
* https://github.com/D4void/MyJoplin
* https://github.com/D4void/zoneminder


A script named services.sh enables starting or stopping these different containers by application.

```
./services.sh {joplin|nextcloud|zm} {up|down}
```

To start or stop everything:

```
docker compose up -d
docker compose down

```