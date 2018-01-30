FROM ubuntu:16.04

# change to aliyun mirror if need
COPY sources.list /etc/apt/sources.list    

# Install MySQL
COPY init_mysql.bash otter-manager-schema.sql /opt/
RUN chmod +x /opt/init_mysql.bash && /opt/init_mysql.bash

# change timezone, e.g. UTC+8
# There is a bug (https://bugs.launchpad.net/ubuntu/+source/tzdata/+bug/1554806, 
# not fixed at the time of writing this answer) in 16.04 which causes the contents of /etc/timezone to be overwritten with the old value when running dpkg-reconfigure -f noninteractive tzdata.
RUN ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && dpkg-reconfigure -f noninteractive tzdata

# add JDK
COPY jdk-8u151-linux-x64.tar.gz /opt/ 
RUN tar -zxf /opt/jdk-8u151-linux-x64.tar.gz -C /opt
ENV PATH="/opt/jdk1.8.0_151/bin:${PATH}"

# add otter-manager
COPY manager.deployer-4.2.15.tar.gz /opt/ 
RUN mkdir /opt/otter-manager
RUN tar -zxf /opt/manager.deployer-4.2.15.tar.gz -C /opt/otter-manager

# add script & otter.properties
COPY otter.properties /opt/otter-manager/conf
COPY start-otter-manager.bash /opt/
RUN chmod +x /opt/start-otter-manager.bash
WORKDIR /opt/otter-manager

EXPOSE 8080 1099
CMD ["/opt/start-otter-manager.bash"]
