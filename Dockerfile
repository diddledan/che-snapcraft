FROM eclipse/stack-base:ubuntu

ENV DEBIAN_FRONTEND noninteractive
# Required by click.
ENV LC_ALL C.UTF-8
ENV SNAPCRAFT_SETUP_CORE 1

RUN sudo apt-get update && \
    sudo apt-get dist-upgrade -y && \
    sudo apt-get install -y \
    git \
    snapcraft \
    && \
    sudo apt-get autoclean --yes && \
    sudo apt-get clean --yes
