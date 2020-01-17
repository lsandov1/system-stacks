This documents provides a possible way to create derived system stacks
containers and include extra software for other uses besides those initially
designed, i.e. power-and-performance, validation, debugging, etc. Other ways
may be designed however this approach is an efficient and clean way to just
add the required SW.


```bash
$ STACK_IMAGE=clearlinux/stacks-mers
$ BUNDLES=dev-utils

$ cat > Dockerfile <<- EOF
FROM clearlinux:latest AS bundles
COPY --from=clearlinux/os-core:latest /usr/lib/os-release /
RUN source /os-release && \\
    mkdir /install_root \\
    && swupd os-install -V \${VERSION_ID} \\
    --path /install_root --statedir /swupd-state \\
    --bundles=$BUNDLES --no-boot-update \\
    && rm -rf /install_root/var/lib/swupd/*

FROM $STACK_IMAGE:latest
USER 0
COPY --from=bundles /install_root /
EOF
```

To generate the docker image based on the new generated docker file, run
`docker-build` cmd i.e `docker build -t mers-dev-utils . && docker run -it mers-dev-utils`.

