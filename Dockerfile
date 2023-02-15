ARG BUILD_DATE
ARG VCS_REF
ARG JACKETT_VERSION=v0.20.3105

FROM alpine:3.17 as build

ARG JACKETT_VERSION

WORKDIR /workdir

RUN case "$(uname -m)" in \
    x86_64)  JACKETT_ARCH="AMDx64" ;; \
    aarch64*)  JACKETT_ARCH="ARM64" ;; \
    armv8?)  JACKETT_ARCH="ARM64" ;; \
    arm64)  JACKETT_ARCH="ARM64" ;; \
    armv[67]?)  JACKETT_ARCH="ARM32" ;; \
    *) exit 1 ;; \
    esac \
    && wget "https://github.com/Jackett/Jackett/releases/download/${JACKETT_VERSION}/Jackett.Binaries.Linux${JACKETT_ARCH}.tar.gz" -O jackett.tgz \
    && mkdir app \
    && tar xzf jackett.tgz --strip-components 1 -C app \
    && chown 0:0 -R app 

WORKDIR /rootfs

RUN cp -r /workdir/app /rootfs/app

COPY --chmod=755 --chown=0:0 --from=busybox:1.36.0-musl /bin/wget /rootfs/wget

FROM mcr.microsoft.com/dotnet/runtime-deps:7.0.3-cbl-mariner2.0-distroless

USER 1000

ARG BUILD_DATE
ARG VCS_REF
ARG JACKETT_VERSION

LABEL org.opencontainers.image.created=$BUILD_DATE \
    org.opencontainers.image.title="jackett-distroless" \
    org.opencontainers.image.description="Distroless container for the Jackett program" \
    org.opencontainers.image.revision=$VCS_REF \
    org.opencontainers.image.version=$JACKETT_VERSION \
    org.opencontainers.image.source="https://github.com/guillaumedsde/jackett-distroless" \
    org.opencontainers.image.authors="guillaumedsde" \
    org.opencontainers.image.vendor="guillaumedsde"

COPY --from=build --chown=0:0 /rootfs /

ENV XDG_CONFIG_HOME=/config \
    DOTNET_SYSTEM_GLOBALIZATION_PREDEFINED_CULTURES_ONLY=false

EXPOSE 9117

HEALTHCHECK  --start-period=15s --interval=30s --timeout=5s --retries=5 \
    CMD [ "/wget", "--quiet", "--tries=1", "--spider", "http://localhost:9117/UI/Login"]

ENTRYPOINT [ "/app/jackett" ]

CMD ["--NoUpdates"]