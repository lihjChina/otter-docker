### build image

1. [download jdk](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html): jdk-8u151-linux-x64.tar.gz && put into each subject folder(e.g. otter-manager)
2. `cd otter-manager` && adjust `Dockerfile` if you need
3. `docker build -t otter-manager:1.0 --rm=true .` to build 
4. same for otter-node/zookeeper

> `docker images -f "dangling=true" -q|xargs docker rmi` to remove dangling images

### create container
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
	
	# cluster	
	docker run -d -e ZK_ID=1 -v /path/to/zoo.cfg:/opt/zookeeper-3.4.10/conf/zoo.cfg --name zk-test1 zookeeper:1.0
	```

### what't more
> utilize `docker logs` to debug

> utilize `docker save & load for image` and `docker export & import for container`

- docker save otter-manager:1.0 | gzip > ~/otter-manager-1.0.tar.gz
- gzip -cd otter-manager-1.0.tar.gz | docker load
