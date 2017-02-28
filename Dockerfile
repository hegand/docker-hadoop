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
ENV HCAT_HOME ${HIVE_HOME}/hcatalog

ENV SQOOP_VERSION 1.4.6
ENV SQOOP_FULL_VERSION sqoop-${SQOOP_VERSION}
ENV SQOOP_HOME /usr/local/sqoop

ENV PATH $PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$HIVE_HOME/bin:$SQOOP_HOME/bin:${HCAT_HOME}/bin

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
        && rm -rf ${HIVE_HOME}/examples \
        && chown -R hive:hive  ${HIVE_HOME}/

RUN set -x \
        && cd /tmp \
        && wget http://apache.claz.org/sqoop/${SQOOP_VERSION}/${SQOOP_FULL_VERSION}.bin__hadoop-2.0.4-alpha.tar.gz  -O - | tar -xz \
        && mv ${SQOOP_FULL_VERSION}.bin__hadoop-2.0.4-alpha /usr/local \
        && mv /usr/local/${SQOOP_FULL_VERSION}.bin__hadoop-2.0.4-alpha /usr/local/${SQOOP_FULL_VERSION} \
        && ln -s /usr/local/${SQOOP_FULL_VERSION} ${SQOOP_HOME} \
        && rm -rf ${SQOOP_HOME}/{docs,ivy,src,testdata,sqoop-test-1.4.6.jar} \
        && chown -R sqoop:sqoop  ${SQOOP_HOME}/
        
RUN set -x \
       && cd /usr/local/lib \
       && wget https://jdbc.postgresql.org/download/postgresql-42.0.0.jar \
       && wget https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.41.tar.gz -O - | tar -xz \
       && mv mysql-connector-java-5.1.41/mysql-connector-java-5.1.41-bin.jar ./ \
       && rm -rf mysql-connector-java-5.1.41 \
       && ln -s /usr/local/lib/postgresql-42.0.0.jar ${HIVE_HOME}/lib/postgresql-42.0.0.jar \
       && ln -s /usr/local/lib/mysql-connector-java-5.1.41-bin.jar ${HIVE_HOME}/lib/mysql-connector-java-5.1.41-bin.jar \
       && ln -s /usr/local/lib/postgresql-42.0.0.jar ${SQOOP_HOME}/lib/postgresql-42.0.0.jar \
       && ln -s /usr/local/lib/mysql-connector-java-5.1.41-bin.jar ${SQOOP_HOME}/lib/mysql-connector-java-5.1.41-bin.jar

RUN mkdir -p /data \
    && chown -R hadoop:hadoop /data

WORKDIR ${HADOOP_HOME}
