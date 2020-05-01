#!/bin/bash

set -euo pipefail
exit 0
kibana_url=http://localhost:5601/api/saved_objects/_import?overwrite=true
kibana_url_wait=http://localhost:5601/app/kibana#/home

while [[ "$(curl -u "admin:admin" -s -o /dev/null -w '%{http_code}' $kibana_url_wait)" != "200" ]]; do
    sleep 5
    echo "waiting.... for $kibana_url_wait"
done
# Set the GPP saved objects.
for filename in ../config/savedObjects/*.ndjson; do
    [ -e "$filename" ] || continue
    until echo "Loading $filename: " && curl -sS -u admin:admin -k -X POST "$kibana_url" -H "kbn-xsrf: true" -H "securitytenant: global_tenant" --form file=@$filename && echo
    do
    	sleep 2
    	echo "Retrying... $filename"
	done

done

#-H "securitytenant: global_tenant" -H "sg_tenant: Global"
#curl -u admin:admin -k -X POST "localhost:5601/api/saved_objects/_import" -H "kbn-xsrf: true" --form file=@1.ndjson