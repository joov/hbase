FROM jsurf/rpi-java:latest
MAINTAINER Johannes Wenzel 

RUN [ "cross-build-start" ]

RUN mkdir /hbase-working
WORKDIR /hbase-working

COPY ./install.sh /hbase-working

RUN apt-get update \
    && apt-get install wget
RUN chmod +x /hbase-setup/install.sh \
    && /hbase-working/install.sh hbase-1.2.3-bin.tar.gz http://apache.mirror.iphh.net/hbase/1.2.3/hbase-1.2.3-bin.tar.gz \
    hbase \
    && mkdir hbase \
    && mkdir zookeeper

COPY ./hbase-site.xml /usr/local/hbase/conf
RUN [ "cross-build-end" ]

# HBase master, master web UI, regionserver, regionserver web UI
EXPOSE 65000    65010          65020         65030

WORKDIR /usr/local/hbase
# CMD /bin/bash
CMD ["/bin/bash", "-c", "bin/start-hbase.sh; bin/hbase shell"]
