FROM diddledan/che-stack-base:ubuntu-1604

EXPOSE 4403 22

ENV DEBIAN_FRONTEND=noninteractive \
    SNAP=/snap/snapcraft/current \
    SNAP_NAME=snapcraft \
    PATH=/snap/bin:$PATH \
    TERM=xterm \
    SNAPCRAFT_BUILD_ENVIRONMENT=host

USER root

RUN apt-get update && \
    apt-get dist-upgrade -yqq && \
    apt-get install -yqq \
        curl \
        sudo \
        jq \
        squashfs-tools && \
    curl -L $(curl -H 'X-Ubuntu-Series: 16' 'https://api.snapcraft.io/api/v1/snaps/details/core' | jq '.download_url' -r) --output core.snap && \
    mkdir -p /snap/core && sudo unsquashfs -d /snap/core/current core.snap && rm core.snap && \
    curl -L $(curl -H 'X-Ubuntu-Series: 16' 'https://api.snapcraft.io/api/v1/snaps/details/snapcraft?channel=stable' | jq '.download_url' -r) --output snapcraft.snap && \
    mkdir -p /snap/snapcraft && sudo unsquashfs -d /snap/snapcraft/current snapcraft.snap && rm snapcraft.snap && \
    apt-get remove -yqq --purge jq squashfs-tools && \
    apt-get -yqq autoclean && \
    apt-get -yqq clean && \
    rm -rf /var/lib/apt/lists/*

COPY bin/snapcraft-wrapper /snap/bin/snapcraft
