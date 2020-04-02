ARG DOCKER_IMAGE=clearlinux:latest
FROM clearlinux:latest AS bundles

# bundles
COPY --from=clearlinux:latest /usr/lib/os-release /
RUN source /os-release && \
    mkdir /install_root \
    && swupd os-install -V ${VERSION_ID} \
    --path /install_root --statedir /swupd-state \
    --bundles=gstreamer --no-boot-update \
    && rm -rf /install_root/var/lib/swupd/*

FROM $DOCKER_IMAGE

# System area (/usr)
COPY --from=bundles /install_root /

