#!/usr/bin/env bash

TF_DOMAIN="/tmp/targets-domain.txt"
TF_HOSTS="/tmp/targets-hosts.txt"
TF_IPS="/tmp/targets-ips.txt"
TF_SERVICES="/tmp/targets-services.txt"
OUT_SUBFINDER="/tmp/OUTPUT-subfinder.jsonl"

ts=$(date +"%Y-%m-%dT%H:%M:%S%z")

subfinder

cat "$OUT_SUBFINDER" | \
while read -r JSON; do 
	JSON=$(echo $JSON | jq ". += {\"timestamp\": \"$ts\", \"@timestamp\":\"$ts\"}")
	IDENTIFIER=$(echo "$JSON" | md5sum | awk '{print $1}');
	if [[ -z "$JSON" ]]; then
		echo "$IDENTIFIER - $TARGET - NO DETECTIONS";
	else
		HNAME=$(jq -r '.host' <<< "$JSON")
		IP=$(jq -r '.ip' <<< "$JSON")
		curl -u "$OPENSEARCH_USER:$OPENSEARCH_PASSWORD" -k -XPOST "$OPENSEARCH_URL/scan-host/_doc/$IDENTIFIER" --json "$JSON" --silent 1>/dev/null
		echo "$IP" >> "$TF_IPS"
		#echo "$IP" >> "$TF_HOSTS"
		echo "$HNAME" >> "$TF_HOSTS"
		echo "HOST DISCOVERED: $HNAME @ $IP";
	fi
done;

# Generate list of IPS for faster portscan
#cat "$TF_DOMAIN" >> "$TF_IPS"
cat "$TF_IPS" | sort | grep -v '^null' | uniq > "/tmp/.targets-ips.txt"
mv "/tmp/.targets-ips.txt" "$TF_IPS"

# Generate list of Hostnames for tlsx 
cat "$TF_DOMAIN" >> "$TF_HOSTS"
cat "$TF_HOSTS" | grep -v '^null' | sort | uniq > "/tmp/.targets-hosts.txt"
mv "/tmp/.targets-hosts.txt" "$TF_HOSTS"

