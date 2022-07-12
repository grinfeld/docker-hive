FROM openjdk:8u265-jre

WORKDIR /opt

ENV HADOOP_HOME=/opt/hadoop-2.10.2
ENV HIVE_HOME=/opt/apache-hive-2.3.9-bin
# Include additional jars
ENV HADOOP_CLASSPATH=/opt/hadoop-2.10.2/share/hadoop/tools/lib/aws-java-sdk-bundle-1.11.271.jar:/opt/hadoop-2.10.2/share/hadoop/tools/lib/hadoop-aws-2.10.2.jar

RUN apt-get update && \
    curl -L https://dlcdn.apache.org/hive/hive-2.3.9/apache-hive-2.3.9-bin.tar.gz | tar zxf - && \
    curl -L https://dlcdn.apache.org/hadoop/common/hadoop-2.10.2/hadoop-2.10.2.tar.gz | tar zxf -

COPY conf ${HIVE_HOME}/conf

RUN groupadd -r hive --gid=1000 && \
    useradd -r -g hive --uid=1000 -d ${HIVE_HOME} hive && \
    chown hive:hive -R ${HIVE_HOME}

USER hive
WORKDIR $HIVE_HOME
EXPOSE 9083

ENTRYPOINT ["bin/hive"]
CMD ["--service", "metastore"]
