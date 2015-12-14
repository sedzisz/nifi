FROM alpine
MAINTAINER clemenko@gmail.com
LABEL VERSION="0.4.0" \
    RUN="docker run -d -p 8080:8080 clemenko/nifi"

ENV DIST_MIRROR http://mirror.cc.columbia.edu/pub/software/apache/nifi
ENV NIFI_HOME /opt/nifi
ENV VERSION 0.4.0

RUN echo "http://dl-4.alpinelinux.org/alpine/v3.3/community/" >> /etc/apk/repositories &&\
  apk update && apk add --upgrade openjdk8 && \
  mkdir -p /opt/nifi && \
  curl ${DIST_MIRROR}/${VERSION}/nifi-${VERSION}-bin.tar.gz | tar xvz -C ${NIFI_HOME} --strip-components=1 && \
  sed -i '/java.arg.1/a java.arg.15=-Djava.security.egd=file:/dev/./urandom' ${NIFI_HOME}/conf/bootstrap.conf && \
  sed -i '/nifi.flow/s#conf/#flow/#g' ${NIFI_HOME}/conf/nifi.properties && \
  mkdir ${NIFI_HOME}/flow && \
  rm -rf /var/cache/apk/*

ADD start_nifi.sh /${NIFI_HOME}/

EXPOSE 80 443 8080
VOLUME ["/opt/certs", "${NIFI_HOME}/flowfile_repository", "${NIFI_HOME}/content_repository", "${NIFI_HOME}/database_repository", "${NIFI_HOME}/content_repository", "${NIFI_HOME}/provenance_repository"]

WORKDIR ${NIFI_HOME}

CMD ["./start_nifi.sh"]
