# [🐋 Jackett-distroless](https://github.com/guillaumedsde/jackett-distroless)

[![Docker Image Version (latest by date)](https://img.shields.io/docker/v/guillaumedsde/jackett-distroless)](https://hub.docker.com/r/guillaumedsde/jackett-distroless/tags)
[![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/guillaumedsde/jackett-distroless)](https://hub.docker.com/r/guillaumedsde/jackett-distroless)
[![Docker Pulls](https://img.shields.io/docker/pulls/guillaumedsde/jackett-distroless)](https://hub.docker.com/r/guillaumedsde/jackett-distroless)
[![GitHub stars](https://img.shields.io/github/stars/guillaumedsde/jackett-distroless?label=Github%20stars)](https://github.com/guillaumedsde/jackett-distroless)
[![GitHub watchers](https://img.shields.io/github/watchers/guillaumedsde/jackett-distroless?label=Github%20Watchers)](https://github.com/guillaumedsde/jackett-distroless)
[![Docker Stars](https://img.shields.io/docker/stars/guillaumedsde/jackett-distroless)](https://hub.docker.com/r/guillaumedsde/jackett-distroless)
[![GitHub](https://img.shields.io/github/license/guillaumedsde/jackett-distroless)](https://github.com/guillaumedsde/jackett-distroless/blob/master/LICENSE.md)

This repository contains the code to build a small and secure distroless **docker** image for **[Jackett](https://github.com/Jackett/Jackett)** running as an unprivileged user.
The final images are built and hosted on the [dockerhub](https://hub.docker.com/r/guillaumedsde/jackett-distroless).

## ✔️ Features summary

- 🥑 [distroless](https://github.com/GoogleContainerTools/distroless) minimal image
- 🤏 As few Docker layers as possible
- 🛡️ only basic runtime dependencies
- 🛡️ Runs as unprivileged user with minimal permissions

## 🏁 How to Run

### `docker run`

```bash
$ docker run  -v /your/config/path/:/config \
              -v /your/torrent/blackhole/path/:/blackhole \
              -p 9117:9117 \
              --user 1000:1000 \
              guillaumedsde/jackett-distroless:latest
```

### `docker-compose.yml`

```yaml
version: "3.3"
services:
  jackett-distroless:
    volumes:
      - "/your/config/path/:/config"
      - "/your/torrent/blackhole/path/:/blackhole"
    ports:
      - "9117:9117"
    user: 1000:1000
    image: "guillaumedsde/jackett-distroless:latest"
```

## 🖥️ Supported platforms

Currently this container supports only one (but widely used) platform:

- linux/amd64
- linux/arm64

## 🙏 Credits

A couple of projects really helped me out while developing this container:

- 💽 [Jackett](https://github.com/Jackett/Jackett) _the_ awesome software
- 🐋 The [Docker](https://github.com/docker) project (of course)
