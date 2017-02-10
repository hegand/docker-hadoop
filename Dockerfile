FROM hegand/jdk:openjdk8

ENV HADOOP_VERSION 2.7.3
ENV HADOOP_FULL_VERSION hadoop-${HADOOP_VERSION}
ENV HADOOP_HOME /usr/local/hadoop
ENV HADOOP_CONF_DIR ${HADOOP_HOME}/conf
ENV PATH $PATH:$HADOOP_HOME/bin

RUN set -x \
        && mkdir -p /usr/local \
        && cd /tmp \
        && wget https://archive.apache.org/dist/hadoop/core/${HADOOP_FULL_VERSION}/${HADOOP_FULL_VERSION}.tar.gz  -O - | tar -xz \
        && mv ${HADOOP_FULL_VERSION} /usr/local \
        && ln -s /usr/local/${HADOOP_FULL_VERSION} ${HADOOP_HOME} \
        && rm -rf ${HADOOP_HOME}/share/doc
        
WORKDIR ${HADOOP_HOME}
