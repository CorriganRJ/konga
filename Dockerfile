ARG BASE_REGISTRY=registry1.dsop.io
ARG BASE_IMAGE=ironbank/redhat/ubi/ubi8
ARG BASE_TAG=8.6
FROM ${BASE_REGISTRY}/${BASE_IMAGE}:${BASE_TAG}

COPY . /app

WORKDIR /app

RUN yum clean all \
    && yum update -y \
    && yum install bash git ca-certificates nodejs -y \
    && npm install -g bower \
    && npm --unsafe-perm --production install \
#    && npm audit fix \
    && yum remove git -y \
    && rm -rf /var/cache/yum/* \
        /app/.git \
        /app/screenshots \
        /app/test \
    && adduser -m -r -u 1200 -s /sbin/nologin konga \
    && mkdir /app/kongadata /app/.tmp \
    && chown -R 1200:1200 /app/views /app/kongadata /app/.tmp

EXPOSE 1337

VOLUME /app/kongadata

ENTRYPOINT ["/app/start.sh"]
