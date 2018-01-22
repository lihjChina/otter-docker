#!/bin/bash -ex

# if ENV set
if [[ -z ${IP+x} ]] || [[ -z ${PORT+x} ]] || [[ -z ${ZK_CLUSTER+x} ]]; then
	echo 'unset ENV $IP & $PORT & $ZK_CLUSTER'
	exit 1
fi

service mysql start

sed -i "s/access_ip_placeholder/$IP/g" /opt/otter-manager/conf/otter.properties
sed -i "s/access_port_placeholder/$PORT/g" /opt/otter-manager/conf/otter.properties
sed -i "s/zookeeper_cluster_placeholder/$ZK_CLUSTER/g" /opt/otter-manager/conf/otter.properties

cd /opt/otter-manager && bash bin/startup.sh && tail -f /opt/otter-manager/logs/manager.log
