# Dev Branch Docker Images

## Overview
The `dev` branch automatically builds and publishes Docker images to GitHub Container Registry (GHCR) on every push. This allows you to run your development features before upstream PRs merge.

## Image Tags

Images are published as:
- `ghcr.io/codename-11/meshmonitor:dev` - Latest dev build (always current)
- `ghcr.io/codename-11/meshmonitor:dev-YYYYMMDD-HHmmss` - Timestamped builds
- `ghcr.io/codename-11/meshmonitor:dev-<commit-sha>` - Specific commit builds

## Usage

### Pull Latest Dev Image

```bash
docker pull ghcr.io/codename-11/meshmonitor:dev
```

### Run Dev Image

**Using docker run:**
```bash
docker run -d \
  -p 8080:3001 \
  -v meshmonitor-data:/data \
  -e MESHTASTIC_HOST=192.168.x.x \
  -e MESHTASTIC_PORT=4403 \
  --name meshmonitor-dev \
  ghcr.io/codename-11/meshmonitor:dev
```

**Using docker-compose:**
```yaml
version: '3.8'
services:
  meshmonitor:
    image: ghcr.io/codename-11/meshmonitor:dev
    container_name: meshmonitor-dev
    ports:
      - "8080:3001"
    volumes:
      - meshmonitor-data:/data
    environment:
      - MESHTASTIC_HOST=192.168.x.x
      - MESHTASTIC_PORT=4403
    restart: unless-stopped

volumes:
  meshmonitor-data:
```

### Update to Latest Dev Build

```bash
docker pull ghcr.io/codename-11/meshmonitor:dev
docker stop meshmonitor-dev
docker rm meshmonitor-dev
# Then run the docker run command above again
```

Or with docker-compose:
```bash
docker-compose pull
docker-compose up -d
```

## Build Trigger

Images are built automatically when:
- You push to the `dev` branch
- You manually trigger the "Docker Dev Build and Publish" workflow from GitHub Actions

## Viewing Published Images

Visit: https://github.com/Codename-11/meshmonitor/pkgs/container/meshmonitor

## Local vs Dev Image

| Method | Use Case | Update Speed |
|--------|----------|--------------|
| `docker-compose.dev.yml` | Active development, testing changes | Immediate (build locally) |
| `ghcr.io/.../meshmonitor:dev` | Running your fork with features not yet in upstream | ~5-10 min after push to dev |
| `ghcr.io/yeraze/meshmonitor:latest` | Production, upstream official releases | Only on upstream releases |

## Workflow

1. Develop feature in `feat/my-feature` branch
2. Test locally with `docker-compose.dev.yml`
3. Open PR to upstream
4. Merge feature to `dev` branch for personal use
5. GitHub Actions automatically builds and publishes dev image
6. Pull and run the dev image on your deployment
7. When upstream merges PR, switch back to upstream image or wait for next release