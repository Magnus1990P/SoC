#!/usr/bin/env bash

TF_NUCLEI="/tmp/targets-services.txt"
OUT_NAABU="/tmp/OUTPUT-naabu.jsonl"

naabu

cat "$OUT_NAABU" | grep -v '^null:' | \
while read -r JSON; do
	IDENTIFIER=$(echo "$JSON" | md5sum | awk '{print $1}');
	if [[ -z "$JSON" ]]; then
		echo "$IDENTIFIER - $TARGET - NO DETECTIONS";
	else 
		HNAME=$(jq -r '.host' <<< "$JSON")
		IP=$(jq -r '.ip' <<< "$JSON")
		PORT=$(jq -r '.port' <<< "$JSON")
		curl -u "$OPENSEARCH_USER:$OPENSEARCH_PASSWORD" -k -XPOST "$OPENSEARCH_URL/scan-port/_doc/$IDENTIFIER" --json "$JSON" 
		curl -u "$OPENSEARCH_USER:$OPENSEARCH_PASSWORD" -k -XPOST "$OPENSEARCH_URL/scan-port/_doc/$IDENTIFIER" --json "$JSON" --silent 1>/dev/null
		echo "PORT DISCOVERED: $HNAME - $IP - $PORT";
	fi
done;

