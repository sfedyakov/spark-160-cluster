# Apache Spark 1.6.0 cluster Docker image
This image is built on top of https://github.com/sfedyakov/hadoop-271-cluster, so please read its documentation first

# Build the image
Before you build, please download the foloowing: Scala 2.10 and Apache Spark 1.6.0.

```
curl -LO https://downloads.typesafe.com/scala/2.10.6/scala-2.10.6.rpm
curl -LO http://apache-mirror.rbc.ru/pub/apache/spark/spark-1.6.0/spark-1.6.0-bin-without-hadoop.tgz
```

If you'd like to try directly from the Dockerfile you can build the image as:

```
sudo docker build -t sfedyakov/spark-160-cluster .
```

# Start cluster

```
docker-compose scale namenode=1 datanode=2
```

You may want to change replication factor to something greater than 1. That's super-easy!

```
for z in $(docker ps -q) ; do docker exec $z sed -i 's/<value>1/<value>2/' /usr/local/hadoop/etc/hadoop/hdfs-site.xml ; done
```


First, prepare test data

```
docker exec -it namenode /bin/bash --login
hdfs dfs -mkdir -p /tmp/wnp/input/ 
curl -LO http://www.gutenberg.org/cache/epub/2600/pg2600.txt 
hdfs dfs -put pg2600.txt /tmp/wnp/input/ 
```


Now run Spark shell

```
spark-shell --master yarn --num-executors 3
```

Count words in War and Peace

```
val lines = sc.textFile("/tmp/wnp/input/pg2600.txt")
lines.flatMap(l => l.split(" ")).map(w => (w.toLowerCase, 1)).reduceByKey(_+_).sortBy(z => (z._2, z._1)).collect().takeRight(50)
```

# Limitations
Same as https://github.com/sfedyakov/hadoop-271-cluster
