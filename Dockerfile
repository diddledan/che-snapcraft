FROM eclipse/stack-base:ubuntu

# ENV DEBIAN_FRONTEND noninteractive
# ENV SNAP=/snap/snapcraft/current
# ENV SNAP_NAME=snapcraft
# ENV PATH=/snap/bin:$PATH
ENV DOCKER_BUCKET get.docker.com
ENV DOCKER_VERSION 1.11.0

RUN set -x \
&& sudo bash -c "wget -qO- https://${DOCKER_BUCKET}/builds/Linux/x86_64/docker-$DOCKER_VERSION.tgz | tar xvz -C /opt/" && sudo mv /opt/docker/* /usr/bin/

# RUN sudo apt-get update && \
#     sudo apt-get dist-upgrade -y && \
#     sudo apt-get install -y \
#     curl sudo jq squashfs-tools && \
#     sudo curl -L $(curl -H 'X-Ubuntu-Series: 16' 'https://api.snapcraft.io/api/v1/snaps/details/core' | jq '.download_url' -r) --output core.snap && \
#     sudo mkdir -p /snap/core && unsquashfs -d /snap/core/current core.snap && rm core.snap && \
#     sudo curl -L $(curl -H 'X-Ubuntu-Series: 16' 'https://api.snapcraft.io/api/v1/snaps/details/snapcraft?channel=stable' | jq '.download_url' -r) --output snapcraft.snap && \
#     sudo mkdir -p /snap/snapcraft && unsquashfs -d /snap/snapcraft/current snapcraft.snap && rm snapcraft.snap && \
#     sudo apt-get remove --yes --purge jq squashfs-tools && \
#     sudo apt-get autoclean --yes && \
#     sudo apt-get clean --yes

# COPY bin/snapcraft-wrapper /snap/bin/snapcraft
