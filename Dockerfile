FROM diddledan/che-stack-base:ubuntu-1604
EXPOSE 4403 8000 8080 9876 22
LABEL che:server:8080:ref=tomcat8 che:server:8080:protocol=http che:server:8000:ref=tomcat8-debug che:server:8000:protocol=http che:server:9876:ref=codeserver che:server:9876:protocol=http

ENV MAVEN_VERSION=3.3.9 \
    JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64 \
    TOMCAT_HOME=/home/user/tomcat8 \
    TERM=xterm
ENV M2_HOME=/home/user/apache-maven-$MAVEN_VERSION
ENV PATH=$JAVA_HOME/bin:$M2_HOME/bin:$PATH

ENV DEBIAN_FRONTEND noninteractive \
    SNAP=/snap/snapcraft/current \
    SNAP_NAME=snapcraft \
    PATH=/snap/bin:$PATH

RUN mkdir /home/user/tomcat8 /home/user/apache-maven-$MAVEN_VERSION && \
    wget -qO- "http://apache.ip-connect.vn.ua/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz" | tar -zx --strip-components=1 -C /home/user/apache-maven-$MAVEN_VERSION/ && \
    wget -qO- "http://archive.apache.org/dist/tomcat/tomcat-8/v8.0.24/bin/apache-tomcat-8.0.24.tar.gz" | tar -zx --strip-components=1 -C /home/user/tomcat8 && \
    rm -rf /home/user/tomcat8/webapps/* && \
    sudo mkdir -p /home/user/.m2 && \
    sudo mkdir -p /home/user/jdtls/data && \
    sudo chgrp -R 0 ${HOME} && \
    sudo chmod -R g+rwX ${HOME}

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

