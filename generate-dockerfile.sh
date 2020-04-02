#!/bin/bash

DOCKER_IMAGE=$1
EXTRA_BUNDLES=$2

cat > Dockerfile <<- EOF
ARG DOCKER_IMAGE=$DOCKER_IMAGE
FROM clearlinux:latest AS bundles

# bundles
COPY --from=$DOCKER_IMAGE /usr/lib/os-release /
RUN source /os-release && \\
    mkdir /install_root \\
    && swupd os-install -V \${VERSION_ID} \\
    --path /install_root --statedir /swupd-state \\
    --bundles=$EXTRA_BUNDLES --no-boot-update \\
    && rm -rf /install_root/var/lib/swupd/*

FROM \$DOCKER_IMAGE

# System area (/usr)
COPY --from=bundles /install_root /

EOF
