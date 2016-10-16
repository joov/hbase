FROM jsurf/rpi-java:latest
MAINTAINER Johannes Wenzel 

RUN [ "cross-build-start" ]

RUN mkdir /hbase-working
WORKDIR /hbase-working

COPY ./install.sh /hbase-working

RUN apt-get update \
    && apt-get install wget
RUN chmod +x /hbase-working/install.sh \
    && /hbase-working/install.sh hbase-1.2.3-bin.tar.gz http://apache.mirror.iphh.net/hbase/1.2.3/hbase-1.2.3-bin.tar.gz \
    hbase \
    && mkdir hbase \
    && mkdir zookeeper

COPY ./hbase-site.xml /usr/local/hbase/conf
RUN [ "cross-build-end" ]

# HBase zookeeper master, master web UI, regionserver, regionserver web UI
EXPOSE  2181      16000   16010          16020         16030

WORKDIR /usr/local/hbase
ENV HBASE_HOME /usr/local/hbase

ENTRYPOINT [  "bin/hbase-daemon.sh" ]
CMD [ "foreground_start", "master" ]
