FROM jsurf/rpi-java:latest
MAINTAINER Johannes Wenzel 

RUN [ "cross-build-start" ]

ENV MAVEN_VERSION 3.3.9
ENV MAVEN_TARBALL apache-maven-${MAVEN_VERSION}-bin.tar.gz


RUN apt-get update \
    && apt-get install git wget

RUN cd /tmp \
   && wget http://apache.mirror.iphh.net/maven/maven-3/${MAVEN_VERSION}/binaries/${MAVEN_TARBALL} \
   && tar xf ${MAVEN_TARBALL} --directory /var/lib \
   && mv /var/lib/apache-maven-* /var/lib/apache-maven \
   && rm ${MAVEN_TARBALL}

ENV PATH "$PATH:/var/lib/apache-maven/bin"


# Pull down HBase and build it into /root/hbase-bin.
RUN git clone http://git.apache.org/hbase.git -b master
RUN mvn clean install -DskipTests assembly:single -f ./hbase/pom.xml \
    && mkdir -p hbase-bin \
    && tar xzf /root/hbase/hbase-assembly/target/*tar.gz --strip-components 1 -C /root/hbase-bin

# Set HBASE_HOME, add it to the path, and start HBase.
ENV HBASE_HOME /root/hbase-bin
ENV PATH /root/hbase-bin/bin:/usr/java/bin:/usr/local/apache-maven/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN  [ "cross-build-end" ]

# zookeeper
EXPOSE 2181
# HBase master
EXPOSE 65000
# HBase master web UI
EXPOSE 65010
# HBase regionserver
EXPOSE 65020
# HBase regionserver web UI
EXPOSE 65030

CMD ["/bin/bash", "-c", "start-hbase.sh; hbase shell"]
