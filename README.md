- [project otter @github](https://github.com/alibaba/otter)
- [project canal @github](https://github.com/alibaba/canal)

### 1. 单机部署 POC
> jdk already setup

[1.a install zookeeper cluster(Standalone)](http://zookeeper.apache.org/doc/current/zookeeperStarted.html)
```
conf/zoo.cfg:

tickTime=2000
dataDir=/var/lib/zookeeper # chown -R xxx:xxx /var/lib/zookeeper
clientPort=2181
```

- To start zookeeper, `bin/zkServer.sh start`
- To test if service running, `bin/zkCli.sh -server 127.0.0.1:2181`

[1.b install manager](https://github.com/alibaba/otter/wiki/Manager_Quickstart)

[1.c install node](https://github.com/alibaba/otter/wiki/Node_Quickstart)

[1.d  Hello world example](https://github.com/alibaba/otter/wiki/QuickStart)

### 2. 使用docker创建mysql数据库测试环境
```
docker pull mysql:5.7
docker run -d -p 127.0.0.1:9000:3306 --name mysql-src-5.7 -v /home/mark/mysql-dockers:/etc/mysql/conf.d -e MYSQL_ROOT_PASSWORD=1234 mysql:5.7

/home/mark/mysql-dockers/my.cnf 
[mysqld]
server-id=1
log-bin=mysql-bin

collation-server = utf8_unicode_ci
init-connect='SET NAMES utf8'
character-set-server = utf8 #默认是latin1, otter并不支持
```
### 3. canal 无法读取docker容器内的binlog??

>  几点说明：(mysql初始化)

a. canal的原理是基于mysql binlog技术，所以这里一定需要开启mysql的binlog写入功能，建议配置binlog模式为row.
**针对阿里云RDS账号默认已经有binlog dump权限,不需要任何权限或者binlog设置,可以直接跳过这一步**
```
[mysqld]
log-bin=mysql-bin #添加这一行就ok
binlog-format=ROW #选择row模式
server_id=1 #配置mysql replaction需要定义，不能和canal的slaveId重复
```

b. canal的原理是模拟自己为mysql slave，所以这里一定需要做为mysql slave的相关权限.
``` sql
CREATE USER canal IDENTIFIED BY 'canal';  
GRANT SELECT, REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO 'canal'@'%';
-- GRANT ALL PRIVILEGES ON *.* TO 'canal'@'%' ;
FLUSH PRIVILEGES;
```

### 4. 数据筛选同步（拓展 EventProcessor）

``` java
public class TestProcessor extends AbstractEventProcessor  {
    public boolean process(EventData eventData) {
        EventColumn testColumn = getColumn(eventData,"test_column");
        if("1".equals(testColumn.getColumnValue())){
            return true;
        }
        return false;
    }
}
```

``` java
import com.alibaba.otter.shared.etl.model.EventColumn;
import com.alibaba.otter.shared.etl.model.EventData;
import com.alibaba.otter.shared.etl.model.EventType;

public class TestProcessor extends AbstractEventProcessor  {
    public boolean process(EventData eventData) {
        EventColumn testColumn = getColumn(eventData,"id");
        //if("1".equals(testColumn.getColumnValue())){
        if(Integer.valueOf(testColumn.getColumnValue()) < 1000){
            return true;
        }
        return false;
    }
} 

```

### 5. Q&A

1. PipeException: download_error
```
pid:1 nid:3 exception:setl:com.alibaba.otter.node.etl.common.pipe.exception.PipeException: download_error
Caused by: com.alibaba.otter.node.etl.common.io.download.exception.DataRetrieveException: aborted for some configration error.
```
> https://github.com/alibaba/otter/issues/78

2. canal elapsed seconds no data 

> https://github.com/alibaba/otter/issues?utf8=%E2%9C%93&q=canal+elapsed+seconds+no+data

### 6. Docker Images

- otter manager
	```
	docker run -d --name manager-test -e IP=127.0.0.1 -e PORT=8080 -e ZK_CLUSTER=127.0.0.1:2181 -p 8080:8080 otter-manager:1.0
	```
- otter node, 
	```
	docker run -d --name otter-node2 -e MANAGER=172.17.0.6:1099 -e NID=2 otter-node:1.0
	```
- zookeeper,
	```
	# standalone
	docker run -d --name zk-test zookeeper:1.0
	```

> utilize `docker logs` to debug

> utilize `docker save & load for image` and `docker export & import for container`

- docker save otter-manager:1.0 | gzip > ~/otter-manager-1.0.tar.gz
- gzip -cd otter-manager-1.0.tar.gz | docker load
