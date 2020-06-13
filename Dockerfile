ARG BUILD_DATE
ARG VCS_REF

FROM alpine as build

ADD https://github.com/just-containers/s6-overlay/releases/latest/download/s6-overlay-amd64.tar.gz s6-overlay-amd64.tar.gz

RUN mkdir -p /rootfs \
    && tar xzf s6-overlay-amd64.tar.gz -C /rootfs 

ADD https://github.com/Jackett/Jackett/releases/latest/download/Jackett.Binaries.LinuxAMDx64.tar.gz Jackett.Binaries.LinuxAMDx64.tar.gz

RUN tar xzf Jackett.Binaries.LinuxAMDx64.tar.gz -C /rootfs \
    && chmod 777 /rootfs/Jackett \
    && cd /rootfs/Jackett \
    && rm *.sh


FROM gcr.io/distroless/dotnet:latest

# Build-time metadata as defined at http://label-schema.org
ARG BUILD_DATE
ARG VCS_REF

LABEL org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.name="nzbhydra2-distroless" \
    org.label-schema.description="Distroless container for the NZBHydra2 program" \
    org.label-schema.url="https://guillaumedsde.gitlab.io/nzbhydra2-distroless/" \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-url="https://github.com/guillaumedsde/nzbhydra2-distroless" \
    org.label-schema.vendor="guillaumedsde" \
    org.label-schema.schema-version="1.0"

COPY --from=build /rootfs /

COPY rootfs /

ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2 \
    PUID=1000 \
    PGID=1000 \
    XDG_CONFIG_HOME=/config

EXPOSE 9117

ENTRYPOINT [ "/init" ]