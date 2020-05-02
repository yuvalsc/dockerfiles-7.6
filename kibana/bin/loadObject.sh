#!/bin/bash

set -euo pipefail

kibana_url=http://localhost:5601/api/saved_objects/_import?overwrite=true
kibana_url_wait=http://localhost:5601/app/kibana#/home
touch_file=/usr/share/kibana/data/ndjson.loaded

if ! [ -f "$touch_file" ]; then
	#return_code=""
	while [[ "$(curl -u "admin:admin" -s -o /dev/null -w '%{http_code}' $kibana_url_wait)" != "200" ]]; do
		sleep 2
	done
	sleep 5
	# Set the GPP saved objects.
	for filename in /usr/share/kibana/config/savedObjects/*.ndjson; do
	    [ -e "$filename" ] || continue
	    until echo "Loading $filename: " && curl -sS -u admin:admin -k -X POST "$kibana_url" -H "kbn-xsrf: true" --form file=@$filename && echo
	    do
	    	sleep 2
		done
	done
	touch $touch_file
fi