FROM python:3.11-alpine3.16

ARG VERSION=master

RUN set -ex && \
    apk add --no-cache build-base openssl leveldb-dev && \
    wget https://github.com/atomicals/atomicals-electrumx/archive/${VERSION}.zip -O /tmp/electrumx.zip && \
    cd /tmp && unzip electrumx.zip && \
    mv /tmp/atomicals-electrumx-${VERSION} /electrumx && \
    cd /electrumx && \
    pip install .[ujson,uvloop,crypto] && \
    apk del build-base && \
    rm -rf /tmp/*

VOLUME ["/data"]

ENV HOME /data
ENV ALLOW_ROOT 1
ENV EVENT_LOOP_POLICY uvloop
ENV DB_DIRECTORY /data
ENV COIN=BitCoin
ENV SERVICES=tcp://:50001,ssl://:50002,wss://:50004,rpc://0.0.0.0:8000
ENV SSL_CERTFILE ${DB_DIRECTORY}/electrumx.crt
ENV SSL_KEYFILE ${DB_DIRECTORY}/electrumx.key
ENV HOST ""

WORKDIR /data

COPY ./bin /usr/local/bin

CMD ["init"]
