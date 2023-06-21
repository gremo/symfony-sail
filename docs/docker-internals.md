
# 🐋 Docker internals

Project [`Dockerfile`](../Dockerfile) is a [multi-stage build](https://docs.docker.com/build/building/multi-stage/) where multiple `FROM` statements are used to build the final artifact(s).

The development flow involves two Docker compose files:

> **Note**: both files are loaded automatically by Visual Studio Code Dev Container extension.

- [`docker-compose.yml`](../docker-compose.yml)
- [`docker-compose.dev.yml`](../docker-compose.dev.yml)

The production flow involves two Docker compose files:

> **Note**: both files are loaded automatically by Docker Compose.

- [`docker-compose.yml`](../docker-compose.yml)
- [`docker-compose.override.yml`](../docker-compose.override.yml)
