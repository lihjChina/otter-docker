FROM ubuntu:16.04

# change to aliyun mirror if need
COPY sources.list /etc/apt/sources.list    
RUN apt-get update && apt-get install build-essential -y && apt-get install file -y && apt-get install tzdata -y

# change timezone, e.g. UTC+8
# There is a bug (https://bugs.launchpad.net/ubuntu/+source/tzdata/+bug/1554806, 
# not fixed at the time of writing this answer) in 16.04 which causes the contents of /etc/timezone to be overwritten with the old value when running dpkg-reconfigure -f noninteractive tzdata.
RUN ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && dpkg-reconfigure -f noninteractive tzdata

# add JDK
COPY jdk-8u151-linux-x64.tar.gz /opt/ 
RUN tar -zxf /opt/jdk-8u151-linux-x64.tar.gz -C /opt
ENV PATH="/opt/jdk1.8.0_151/bin:${PATH}"

# add otter node
COPY node.deployer-4.2.15.tar.gz /opt/
RUN mkdir /opt/otter-node
RUN tar -zxf /opt/node.deployer-4.2.15.tar.gz -C /opt/otter-node
RUN touch /opt/otter-node/conf/nid

# install aria2c
COPY aria2-1.33.1.tar.gz /opt/
RUN tar -zxf /opt/aria2-1.33.1.tar.gz -C /opt
WORKDIR /opt/aria2-1.33.1
# https://github.com/aria2/aria2
RUN ./configure
RUN make
RUN make install

# add script & otter.properties
COPY otter.properties /opt/otter-node/conf
COPY start-otter-node.bash /opt/
RUN chmod +x /opt/start-otter-node.bash
WORKDIR /opt/otter-node

EXPOSE 2088 9090 
CMD ["/opt/start-otter-node.bash"]
