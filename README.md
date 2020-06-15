# [🐋 Jackett-distroless](https://github.com/guillaumedsde/jackett-distroless)

[![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/guillaumedsde/jackett-distroless)](https://hub.docker.com/r/guillaumedsde/jackett-distroless/builds)
[![Gitlab pipeline status](https://img.shields.io/gitlab/pipeline/guillaumedsde/jackett-distroless?label=documentation)](https://guillaumedsde.gitlab.io/jackett-distroless/)
[![Docker Cloud Automated build](https://img.shields.io/docker/cloud/automated/guillaumedsde/jackett-distroless)](https://hub.docker.com/r/guillaumedsde/jackett-distroless/builds)
[![Docker Image Version (latest by date)](https://img.shields.io/docker/v/guillaumedsde/jackett-distroless)](https://hub.docker.com/r/guillaumedsde/jackett-distroless/tags)
[![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/guillaumedsde/jackett-distroless)](https://hub.docker.com/r/guillaumedsde/jackett-distroless)
[![Docker Pulls](https://img.shields.io/docker/pulls/guillaumedsde/jackett-distroless)](https://hub.docker.com/r/guillaumedsde/jackett-distroless)
[![GitHub stars](https://img.shields.io/github/stars/guillaumedsde/jackett-distroless?label=Github%20stars)](https://github.com/guillaumedsde/jackett-distroless)
[![GitHub watchers](https://img.shields.io/github/watchers/guillaumedsde/jackett-distroless?label=Github%20Watchers)](https://github.com/guillaumedsde/jackett-distroless)
[![Docker Stars](https://img.shields.io/docker/stars/guillaumedsde/jackett-distroless)](https://hub.docker.com/r/guillaumedsde/jackett-distroless)
[![GitHub](https://img.shields.io/github/license/guillaumedsde/jackett-distroless)](https://github.com/guillaumedsde/jackett-distroless/blob/master/LICENSE.md)

This repository contains the code to build a small and secure **[distroless](https://github.com/GoogleContainerTools/distroless)** **docker** image for **[Jackett](https://github.com/Jackett/Jackett)** running as an unprivileged user.
The final images are built and hosted on the [dockerhub](https://hub.docker.com/r/guillaumedsde/jackett-distroless) and the documentation is hosted on [gitlab pages](https://guillaumedsde.gitlab.io/jackett-distroless/)

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
              -v /etc/localtime:/etc/localtime:ro \
              -e PUID=1000 \
              -e PGID=1000 \
              -p 9117:9117 \
              guillaumedsde/jackett-distroless:latest
```

#### 🧊 Read-only `docker run`

If you want your container to be _even_ more secure, you can run it with a read-only filesystem:

```bash
$ docker run  -v /your/config/path/:/config \
              -v /your/torrent/blackhole/path/:/blackhole \
              -v /etc/localtime:/etc/localtime:ro \
              -e PUID=1000 \
              -e PGID=1000 \
              -e S6_READ_ONLY_ROOT=1 \
              -p 9117:9117 \
              --read-only \
              --tmpfs /var:rw,exec \
              --tmpfs /tmp \
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
      - "/etc/localtime:/etc/localtime:ro"
    environment:
      - PUID=1000
      - PGID=1000
    ports:
      - "9117:9117"
    image: "guillaumedsde/jackett-distroless:latest"
```

#### 🧊 Read-only `docker-compose.yml` Read-only

If you want your container to be _even_ more secure, you can run it with a read-only filesystem:

```yaml
version: "3.3"
services:
  jackett-distroless:
    volumes:
      - "/your/config/path/:/config"
      - "/your/torrent/blackhole/path/:/blackhole"
      - "/etc/localtime:/etc/localtime:ro"
    environment:
      - PUID=1000
      - PGID=1000
      - S6_READ_ONLY_ROOT=1
    ports:
      - "9117:9117"
    tmpfs:
      - "/var:rw,exec"
      - "/tmp:rw,exec"
    read_only: true
    image: "guillaumedsde/jackett-distroless:latest"
```

## 🖥️ Supported platforms

Currently this container supports only one (but widely used) platform:

- linux/amd64

I am waiting to see if Google implement their distroless Java images for other platforms (e.g. ARM based), for more information, see [here](https://github.com/GoogleContainerTools/distroless/issues/406) or [here](https://github.com/GoogleContainerTools/distroless/issues/377)

## 🙏 Credits

A couple of projects really helped me out while developing this container:

- 💽 [Jackett](https://github.com/Jackett/Jackett) _the_ awesome software
- 🏁 [s6-overlay](https://github.com/just-containers/s6-overlay) A simple, relatively small yet powerful set of init script for managing processes (especially in docker containers)
- 🥑 [Google's distroless](https://github.com/GoogleContainerTools/distroless) base docker images
- 🐋 The [Docker](https://github.com/docker) project (of course)
