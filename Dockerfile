FROM hegand/jdk:openjdk8

ENV HADOOP_VERSION 2.7.3
ENV HADOOP_FULL_VERSION hadoop-${HADOOP_VERSION}
ENV HADOOP_HOME /usr/local/hadoop
ENV HADOOP_CONF_DIR ${HADOOP_HOME}/conf
ENV HADOOP_OPTS	-Djava.library.path=/usr/local/hadoop/lib/native
ENV PATH $PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin

RUN apk add --update --no-cache bash

RUN set -x \
        && mkdir -p /usr/local \
        && cd /tmp \
        && wget https://archive.apache.org/dist/hadoop/core/${HADOOP_FULL_VERSION}/${HADOOP_FULL_VERSION}.tar.gz  -O - | tar -xz \
        && mv ${HADOOP_FULL_VERSION} /usr/local \
        && ln -s /usr/local/${HADOOP_FULL_VERSION} ${HADOOP_HOME} \
        && rm -rf ${HADOOP_HOME}/share/doc

RUN mkdir -p /data

RUN adduser -D -s /bin/bash -h ${HADOOP_HOME} -u 1100 hadoop \
    && chown -R hadoop:hadoop  ${HADOOP_HOME} /data

WORKDIR ${HADOOP_HOME}
