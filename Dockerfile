FROM hegand/jdk:openjdk8

ENV HADOOP_VERSION 2.7.3
ENV HADOOP_MAJOR_VERSION 2.7
ENV HADOOP_FULL_VERSION hadoop-${HADOOP_VERSION}
ENV HADOOP_HOME /usr/local/hadoop
ENV HADOOP_CONF_DIR ${HADOOP_HOME}/conf
ENV HADOOP_OPTS	-Djava.library.path=$HADOOP_HOME/lib/native
ENV PATH $PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin

RUN apk add --update --no-cache bash

RUN adduser -D -s /bin/bash -u 1100 hadoop

RUN set -x \
        && mkdir -p /usr/local \
        && cd /tmp \
        && wget https://archive.apache.org/dist/hadoop/core/${HADOOP_FULL_VERSION}/${HADOOP_FULL_VERSION}.tar.gz  -O - | tar -xz \
        && mv ${HADOOP_FULL_VERSION} /usr/local \
        && ln -s /usr/local/${HADOOP_FULL_VERSION} ${HADOOP_HOME} \
        && rm -rf ${HADOOP_HOME}/share/doc \
        && chown -R hadoop:hadoop  ${HADOOP_HOME}/
        
RUN set -x \
        && mkdir -p /usr/share/java \
        && cd /usr/share/java \
        && wget http://central.maven.org/maven2/org/xerial/snappy/snappy-java/1.1.2.6/snappy-java-1.1.2.6.jar \
        && ln -s /usr/share/java/snappy-java-1.1.2.6.jar /usr/share/java/snappy-java.jar \
        && ln -s /usr/share/java/snappy-java-1.1.2.6.jar $HADOOP_HOME/share/hadoop/hdfs/lib/snappy-java-1.1.2.6.jar \
        && ln -s /usr/share/java/snappy-java-1.1.2.6.jar $HADOOP_HOME/share/hadoop/yarn/lib/snappy-java-1.1.2.6.jar

RUN mkdir -p /data \
    && chown -R hadoop:hadoop /data

WORKDIR ${HADOOP_HOME}
