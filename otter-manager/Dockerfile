FROM ubuntu:16.04

# change to aliyun mirror if need
COPY sources.list /etc/apt/sources.list    

# Install MySQL
COPY init_mysql.bash otter-manager-schema.sql /opt/
RUN chmod +x /opt/init_mysql.bash && /opt/init_mysql.bash

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
