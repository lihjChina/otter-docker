FROM ubuntu:16.04

# change to aliyun mirror if need
COPY sources.list /etc/apt/sources.list    
RUN apt-get update

# add JDK
COPY jdk-8u151-linux-x64.tar.gz /opt/ 
RUN tar -zxf /opt/jdk-8u151-linux-x64.tar.gz -C /opt
ENV PATH="/opt/jdk1.8.0_151/bin:${PATH}"

# add zookeeper
COPY zookeeper-3.4.10.tar.gz start-zk.bash /opt/ 
RUN tar -zxf /opt/zookeeper-3.4.10.tar.gz -C /opt && chmod +x /opt/start-zk.bash
COPY zoo.cfg /opt/zookeeper-3.4.10/conf/
RUN mkdir /var/lib/zookeeper && touch /var/lib/zookeeper/myid

#VOLUME /opt/zookeeper-3.4.10/conf/zoo.cfg
EXPOSE 2181 2888 3888
CMD ["/opt/start-zk.bash"]
