FROM hegand/jdk:openjdk8

ENV HADOOP_VERSION 2.7.3
ENV HADOOP_MAJOR_VERSION 2.7
ENV HADOOP_FULL_VERSION hadoop-${HADOOP_VERSION}
ENV HADOOP_HOME /usr/local/hadoop
ENV HADOOP_CONF_DIR ${HADOOP_HOME}/conf
ENV HADOOP_OPTS	-Djava.library.path=/usr/local/hadoop/lib/native

ENV HIVE_VERSION 2.1.1
ENV HIVE_FULL_VERSION hive-${HIVE_VERSION}
ENV HIVE_HOME /usr/local/hive

ENV SQOOP_VERSION 1.4.6
ENV SQOOP_FULL_VERSION sqoop-${SQOOP_VERSION}
ENV SQOOP_HOME /usr/local/sqoop

ENV PATH $PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$HIVE_HOME/bin:$SQOOP_HOME/bin

RUN apk add --update --no-cache bash

RUN set -x \
        && adduser -D -s /bin/bash -u 1100 hadoop \
        && adduser -D -s /bin/bash -u 1110 yarn \
        && adduser -D -s /bin/bash -u 1120 mapred \
        && adduser -D -s /bin/bash -u 1130 hive \
        && adduser -D -s /bin/bash -u 1140 sqoop

RUN set -x \
        && mkdir -p /usr/local \
        && cd /tmp \
        && wget https://archive.apache.org/dist/hadoop/core/${HADOOP_FULL_VERSION}/${HADOOP_FULL_VERSION}.tar.gz  -O - | tar -xz \
        && mv ${HADOOP_FULL_VERSION} /usr/local \
        && ln -s /usr/local/${HADOOP_FULL_VERSION} ${HADOOP_HOME} \
        && rm -rf ${HADOOP_HOME}/share/doc \
        && chown -R hadoop:hadoop  ${HADOOP_HOME}/

RUN set -x \
        && cd /tmp \
        && wget http://apache.claz.org/hive/${HIVE_FULL_VERSION}/apache-${HIVE_FULL_VERSION}-bin.tar.gz  -O - | tar -xz \
        && mv apache-${HIVE_FULL_VERSION}-bin /usr/local \
        && ln -s /usr/local/apache-${HIVE_FULL_VERSION}-bin ${HIVE_HOME} \
        && chown -R hive:hive  ${HIVE_HOME}/

RUN set -x \
        && cd /tmp \
        && wget http://apache.claz.org/sqoop/${SQOOP_VERSION}/${SQOOP_FULL_VERSION}.tar.gz  -O - | tar -xz \
        && mv ${SQOOP_FULL_VERSION} /usr/local \
        && ln -s /usr/local/${SQOOP_FULL_VERSION} ${SQOOP_HOME} \
        && chown -R sqoop:sqoop  ${SQOOP_HOME}/

RUN mkdir -p /data \
    && chown -R hadoop:hadoop /data

WORKDIR ${HADOOP_HOME}
