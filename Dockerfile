FROM ubuntu:xenial

RUN apt-get -y update && \
    apt-get -y install software-properties-common && \
    add-apt-repository ppa:bitcoin-unlimited/bu-ppa && \
    apt-get -y update && \
    apt-get -y install bitcoind=0.12.1c

# Grab gosu for easy step-down from root
ENV GOSU_VERSION 1.7
RUN set -x && \
    apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates wget && \
    rm -rf /var/lib/apt/lists/* && \
    wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" && \
    wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" && \
    export GNUPGHOME="$(mktemp -d)" && \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 && \
    gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu && \
    rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc && \
    chmod +x /usr/local/bin/gosu && \
    gosu nobody true && \
    apt-get purge -y --auto-remove ca-certificates wget

RUN adduser --home /var/lib/bitcoin/ --disabled-login --disabled-password --gecos "" bitcoin

EXPOSE 8333 18333
ADD start.sh /opt/start.sh
ENTRYPOINT ["/opt/start.sh"]
CMD ["bitcoind"]
