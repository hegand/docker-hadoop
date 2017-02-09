FROM hegand/jdk:openjdk8

ENV HADOOP_VERSION 2.7.3
ENV HADOOP_FULL_VERSION hadoop-${HADOOP_VERSION}
ENV HADOOP_HOME /usr/local/hadoop
ENV HADOOP_CONF_DIR ${HADOOP_HOME}/conf
ENV PATH $PATH:$HADOOP_HOME/bin

RUN set -x \
        && mkdir -p ${HADOOP_HOME} \
        && cd /tmp \
        && wget https://archive.apache.org/dist/hadoop/core/${HADOOP_FULL_VERSION}/${HADOOP_FULL_VERSION}.tar.gz \
        && tar zxf ${HADOOP_FULL_VERSION}.tar.gz \
        && mv ${HADOOP_FULL_VERSION} /usr/local/hadoop
        && rm ${HADOOP_FULL_VERSION}.tar.gz
        && cd ${HADOOP_HOME}
