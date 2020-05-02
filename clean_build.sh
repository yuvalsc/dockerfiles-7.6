#!/bin/bash

docker stop logstash-node1 stop kib-node1 es-node1
docker rm -f $(docker ps -a -q)
docker rmi -f $(docker images -f dangling=true -a -q)
docker rmi -f yuvalsc/mon-gpp-logstash yuvalsc/mon-gpp-kibana yuvalsc/mon-gpp-elastic
docker rmi -f $(docker images -f dangling=true -a -q)
docker volume rm $(docker volume ls -q)
docker network rm $(docker network ls | tail -n+2 | awk '{if($2 !~ /bridge|none|host/){ print $1 }}')
docker network create gpp-mon-net

cd /Users/yuvals/docker/dockerfiles-7.6
docker build --rm --tag yuvalsc/mon-gpp-elastic elasticsearch
docker build --rm --tag yuvalsc/mon-gpp-kibana kibana
docker build --rm --tag yuvalsc/mon-gpp-logstash logstash

docker rmi -f $(docker images -f dangling=true -a -q)



docker run --rm -p 9200:9200 -p 9600:9600 --name es-node1 --network=gpp-mon-net -d yuvalsc/mon-gpp-elastic
docker run --rm -p 5601:5601 --name kib-node1 --network=gpp-mon-net -d yuvalsc/mon-gpp-kibana
docker run --rm -p 5044:5044 --name logstash-node1 --network=gpp-mon-net yuvalsc/mon-gpp-logstash