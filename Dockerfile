# Creates Spark cluster on YARN

FROM sfedyakov/hadoop-271-cluster
MAINTAINER Stas Fedyakov Stanislav.Fedyakov@gmail.com

USER root

# scala
ADD scala-2.10.6.rpm /tmp/
RUN rpm -i /tmp/scala-2.10.6.rpm && \
    rm /tmp/scala-2.10.6.rpm 

# spark
ADD spark-1.6.0-bin-without-hadoop.tgz /usr/local/
RUN cd /usr/local && ln -s ./spark-1.6.0-bin-without-hadoop/ spark

ENV SPARK_HOME=/usr/local/spark \
    SCALA_HOME=/usr/share/scala \
    PATH=$PATH:/usr/local/spark/bin

ADD spark-env.sh $SPARK_HOME/conf/spark-env.sh

