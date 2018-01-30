
### build image

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
	```

### what't more
> utilize `docker logs` to debug

> utilize `docker save & load for image` and `docker export & import for container`

- docker save otter-manager:1.0 | gzip > ~/otter-manager-1.0.tar.gz
- gzip -cd otter-manager-1.0.tar.gz | docker load
