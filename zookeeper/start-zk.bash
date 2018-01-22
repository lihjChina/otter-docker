#!/bin/bash

cd /opt/zookeeper-3.4.10 && ./bin/zkServer.sh start && tail -f zookeeper.out
