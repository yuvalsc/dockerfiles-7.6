#!/bin/bash

docker rm -f $(docker ps -a -q)

docker rmi -f $(docker images -a -q)
docker volume rm $(docker volume ls -q)
docker network rm $(docker network ls | tail -n+2 | awk '{if($2 !~ /bridge|none|host/){ print $1 }}')
docker build --tag yuvalsc/mon-gpp-elastic elasticsearch
docker build --tag yuvalsc/mon-gpp-kibana kibana
#docker build --tag yuvalsc/mon-gpp-logstash logstash

docker run --rm -p 9200:9200 -p 9600:9600 --name es-node1 -d yuvalsc/mon-gpp-elastic
docker run --rm -p 5601:5601 --name kib-node1 --link es-node1 yuvalsc/mon-gpp-kibana