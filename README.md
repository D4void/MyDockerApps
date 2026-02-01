# MyDockerApps

A unified Docker Compose orchestrator for managing multiple self-hosted applications behind a shared Traefik reverse proxy.

## Overview

This project leverages Docker Compose's `include` directive to create a single composition that manages:

- **[MyTraefik](https://github.com/D4void/MyTraefik)** - Traefik v2.11 reverse proxy with Let's Encrypt SSL
- **[MyJoplin](https://github.com/D4void/MyJoplin)** - Joplin Server for note synchronization
- **[MyNextCloud](https://github.com/D4void/MyNextCloud)** - Nextcloud with Collabora Online integration
- **[Zoneminder](https://github.com/D4void/zoneminder)** - Video surveillance system

All applications share the same Traefik instance for SSL termination, routing, and security middleware.

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                      MyDockerApps                           │
│                    (Orchestrator)                           │
├─────────────────────────────────────────────────────────────┤
│  include:                                                   │
│    ├── MyTraefik/docker-compose.yml      (Reverse Proxy)    │
│    ├── MyJoplin/docker-compose.yml       (Note Sync)        │
│    ├── zoneminder/docker-compose.yml     (Surveillance)     │
│    └── MyNextCloud/docker-compose.yml    (Cloud Storage)    │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                     MyTraefikNet                            │
│              (Shared Docker Network)                        │
│                                                             │
│   ┌─────────┐  ┌─────────┐  ┌──────────┐  ┌─────────────┐   │
│   │ Traefik │  │ Joplin  │  │Zoneminder│  │  Nextcloud  │   │
│   │  :443   │  │ Server  │  │  Server  │  │  + Collabora│   │
│   └─────────┘  └─────────┘  └──────────┘  └─────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

## Prerequisites

1. **Directory Structure**: All projects must be siblings in the same parent directory:
   ```
   /your/projects/
   ├── MyDockerApps/     # This orchestrator
   ├── MyTraefik/        # Traefik reverse proxy
   ├── MyJoplin/         # Joplin server
   ├── MyNextCloud/      # Nextcloud stack
   └── zoneminder/       # Zoneminder (lowercase 'z')
   ```

2. **Individual Project Setup**: Each included project must be configured with its own `.env` file:
   - `MyTraefik/.env` - Network configuration, Let's Encrypt email
   - `MyJoplin/.env` - Database credentials, domain settings
   - `MyNextCloud/.env` - Database, Redis, domain configuration
   - `zoneminder/.env` - Database and volume paths

3. **Docker & Docker Compose**: Ensure Docker Compose v2+ is installed (uses `docker compose` syntax).

## Usage

### Full Stack Management

Start all services (Traefik starts first, then all applications):

```bash
docker compose up -d
```

Stop all services:

```bash
docker compose down
```

View logs for all services:

```bash
docker compose logs -f
```

### Selective Service Management

Use the `services.sh` script to start or stop individual applications without affecting others:

```bash
./services.sh <service> <action>
```

**Available services:**
| Service | Containers |
|---------|------------|
| `joplin` | `joplin_app`, `joplin_db` |
| `nextcloud` | `nc-nextcloud`, `nc-db`, `nc-redis`, `nc-collabora`, `nc-cron` |
| `zm` | `zm`, `zm-db` |

**Examples:**

```bash
# Start only Joplin
./services.sh joplin up

# Stop only Nextcloud
./services.sh nextcloud down

# Start only Zoneminder
./services.sh zm up
```

### Viewing Service Logs

```bash
# Traefik access logs
docker compose logs -f traefik

# Joplin application logs
docker compose logs -f joplin_app

# Nextcloud logs
docker compose logs -f nc-nextcloud

# Zoneminder logs
docker compose logs -f zm
```

### Checking Service Status

```bash
docker compose ps
```

## How It Works

The `docker-compose.yml` uses Docker Compose's `include` directive to merge multiple standalone projects:

```yaml
include:
  - path: '../MyTraefik/docker-compose.yml'
  - path: '../MyJoplin/docker-compose.yml'
  - path: '../zoneminder/docker-compose.yml'
  - path: '../MyNextCloud/docker-compose.yml'
```

**Key benefits:**
- All services share Traefik's `MyTraefikNet` network
- Single command deploys the entire stack
- Each included project remains independently deployable
- Centralized dependency management (all services depend on Traefik)

## Exit Codes (services.sh)

| Code | Description |
|------|-------------|
| `0` | Success |
| `1` | Wrong number of arguments |
| `2` | Invalid action (must be `up` or `down`) |
| `3` | Unknown service name |

## Troubleshooting

### Services fail to start
- Ensure each project has its `.env` file properly configured
- Verify `MyTraefikNet` network exists: `docker network ls | grep MyTraefikNet`
- Check Traefik is running: `docker compose ps traefik`

### Network conflicts
- The `MyTraefikNet` subnet must not conflict with existing Docker networks or LAN subnets
- Check for conflicts: `docker network inspect MyTraefikNet`

### Path issues
- All project directories must be at the same level with exact names as referenced in `docker-compose.yml`
- Note: `zoneminder` uses lowercase 'z' in the path

## License

See individual project repositories for licensing information.

## Related Projects

- [MyTraefik](https://github.com/D4void/MyTraefik) - Traefik reverse proxy configuration
- [MyJoplin](https://github.com/D4void/MyJoplin) - Joplin Server deployment
- [MyNextCloud](https://github.com/D4void/MyNextCloud) - Nextcloud with SMB support
- [Zoneminder](https://github.com/D4void/zoneminder) - Video surveillance system