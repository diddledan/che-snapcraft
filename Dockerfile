FROM diddledan/che-stack-base:ubuntu-1804
EXPOSE 4403 22

ENV DEBIAN_FRONTEND noninteractive \
    SNAP=/snap/snapcraft/current \
    SNAP_NAME=snapcraft \
    PATH=/snap/bin:$PATH
    TERM=xterm

RUN sudo apt-get update && \
    sudo apt-get dist-upgrade -y && \
    sudo apt-get install -y \
    curl sudo jq squashfs-tools && \
    sudo curl -L $(curl -H 'X-Ubuntu-Series: 16' 'https://api.snapcraft.io/api/v1/snaps/details/core' | jq '.download_url' -r) --output core.snap && \
    sudo mkdir -p /snap/core && unsquashfs -d /snap/core/current core.snap && rm core.snap && \
    sudo curl -L $(curl -H 'X-Ubuntu-Series: 16' 'https://api.snapcraft.io/api/v1/snaps/details/snapcraft?channel=stable' | jq '.download_url' -r) --output snapcraft.snap && \
    sudo mkdir -p /snap/snapcraft && unsquashfs -d /snap/snapcraft/current snapcraft.snap && rm snapcraft.snap && \
    sudo apt-get remove --yes --purge jq squashfs-tools && \
    sudo apt-get autoclean --yes && \
    sudo apt-get clean --yes

COPY bin/snapcraft-wrapper /snap/bin/snapcraft

