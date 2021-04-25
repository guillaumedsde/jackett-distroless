ARG BUILD_DATE
ARG VCS_REF
ARG JACKETT_VERSION=latest

FROM alpine:3.13 as build

ARG JACKETT_VERSION

ADD https://github.com/just-containers/s6-overlay/releases/latest/download/s6-overlay-amd64.tar.gz s6-overlay-amd64.tar.gz

RUN mkdir -p /rootfs \
    && tar xzf s6-overlay-amd64.tar.gz -C /rootfs 

RUN if [ "${JACKETT_VERSION}" = "latest" ]; then wget "https://github.com/Jackett/Jackett/releases/latest/download/Jackett.Binaries.LinuxAMDx64.tar.gz" ; \
    else wget "https://github.com/Jackett/Jackett/releases/download/${JACKETT_VERSION}/Jackett.Binaries.LinuxAMDx64.tar.gz"; fi

RUN tar xzf Jackett.Binaries.LinuxAMDx64.tar.gz -C /rootfs \
    && chmod 755 /rootfs/Jackett/jackett \
    && cd /rootfs/Jackett \
    && rm *.sh

ARG BUSYBOX_VERSION=1.31.0-i686-uclibc
ADD https://busybox.net/downloads/binaries/$BUSYBOX_VERSION/busybox_WGET /rootfs/wget
RUN chmod a+x /rootfs/wget

FROM gcr.io/distroless/dotnet:latest as distroless

# Build-time metadata as defined at http://label-schema.org
ARG BUILD_DATE
ARG VCS_REF
ARG JACKETT_VERSION

LABEL org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.name="jackett-distroless" \
    org.label-schema.description="Distroless container for the Jackett program" \
    org.label-schema.url="https://guillaumedsde.gitlab.io/jackett-distroless/" \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.version=$JACKETT_VERSION-distroless \
    org.label-schema.vcs-url="https://github.com/guillaumedsde/jackett-distroless" \
    org.label-schema.vendor="guillaumedsde" \
    org.label-schema.schema-version="1.0"

COPY --from=build /rootfs/wget /rootfs/Jackett /

ENV XDG_CONFIG_HOME=/config

EXPOSE 9117

VOLUME /blackhole

HEALTHCHECK  --start-period=15s --interval=30s --timeout=5s --retries=5 \
    CMD [ "/wget", "--quiet", "--tries=1", "--spider", "http://localhost:9117/UI/Login"]

ENTRYPOINT [ "/Jackett/jackett" ]

CMD ["--NoUpdates"]

FROM gcr.io/distroless/dotnet:latest as s6

# Build-time metadata as defined at http://label-schema.org
ARG BUILD_DATE
ARG VCS_REF
ARG JACKETT_VERSION

LABEL org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.name="jackett-distroless" \
    org.label-schema.description="Distroless container for the Jackett program" \
    org.label-schema.url="https://guillaumedsde.gitlab.io/jackett-distroless/" \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.version=$JACKETT_VERSION-s6-overlay \
    org.label-schema.vcs-url="https://github.com/guillaumedsde/jackett-distroless" \
    org.label-schema.vendor="guillaumedsde" \
    org.label-schema.schema-version="1.0"

COPY --from=build /rootfs /

COPY rootfs /

ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2 \
    PUID=1000 \
    PGID=1000 \
    XDG_CONFIG_HOME=/config

EXPOSE 9117

VOLUME /blackhole

HEALTHCHECK  --start-period=15s --interval=30s --timeout=5s --retries=5 \
    CMD [ "/wget", "--quiet", "--tries=1", "--spider", "http://localhost:9117/UI/Login"]

ENTRYPOINT [ "/init" ]