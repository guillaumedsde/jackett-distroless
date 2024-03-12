FROM docker.io/alpine:3.19 as build

ARG VERSION

WORKDIR /workdir

RUN case "$(uname -m)" in \
    x86_64)  JACKETT_ARCH="AMDx64" ;; \
    aarch64*)  JACKETT_ARCH="ARM64" ;; \
    armv8?)  JACKETT_ARCH="ARM64" ;; \
    arm64)  JACKETT_ARCH="ARM64" ;; \
    armv[67]?)  JACKETT_ARCH="ARM32" ;; \
    *) exit 1 ;; \
    esac \
    && wget --quiet "https://github.com/Jackett/Jackett/releases/download/${VERSION}/Jackett.Binaries.Linux${JACKETT_ARCH}.tar.gz" -O jackett.tgz \
    && mkdir app /rootfs \
    && tar xzf jackett.tgz --strip-components 1 -C app \
    && chown 0:0 -R app \
    && mv app /rootfs/

WORKDIR /rootfs

COPY --chmod=755 --chown=0:0 --from=busybox:1.36.1-musl /bin/wget /rootfs/wget

FROM mcr.microsoft.com/dotnet/runtime-deps:7.0.17-cbl-mariner2.0-distroless

USER 1000

COPY --from=build --chown=1000:1000 /rootfs /

ENV XDG_CONFIG_HOME=/config \
    DOTNET_SYSTEM_GLOBALIZATION_PREDEFINED_CULTURES_ONLY=false

EXPOSE 9117

HEALTHCHECK  --start-period=15s --interval=30s --timeout=5s --retries=5 \
    CMD [ "/wget", "--quiet", "--tries=1", "--spider", "http://localhost:9117/UI/Login"]

ENTRYPOINT [ "/app/jackett" ]

CMD ["--NoUpdates"]