#!/usr/bin/env bash

OSIndex=scan-port
OSIndex=testbed

TF_NUCLEI="/tmp/targets-nuclei.txt"
OUT_NAABU="/tmp/OUTPUT-naabu.jsonl"

#naabu
naabu -p $(cat /tmp/portlist.txt)

cat "$OUT_NAABU" | grep -v '^null:' | \
while read -r JSON; do
	IDENTIFIER=$(echo "$JSON" | md5sum | awk '{print $1}');
	if [[ -z "$JSON" ]]; then
		echo "$IDENTIFIER - $TARGET - NO DETECTIONS";
	else 
		HNAME=$(jq -r '.host' <<< "$JSON")
		IP=$(jq -r '.ip' <<< "$JSON")
		PORT=$(jq -r '.port' <<< "$JSON")
		curl -u "$OPENSEARCH_USER:$OPENSEARCH_PASSWORD" -k -XPOST "$OPENSEARCH_URL/$OSIndex/_doc/$IDENTIFIER" --json "$JSON" --silent 1>/dev/null
		echo "PORT DISCOVERED: $HNAME - $IP - $PORT";
		echo "$IP:$PORT" >> $TF_NUCLEI
		echo "$HNAME:$PORT" >> $TF_NUCLEI
	fi
done;

cat "$TF_NUCLEI" | grep -v "^null" | sort | uniq >> "$TF_NUCLEI.tmp"
mv "$TF_NUCLEI.tmp" "$TF_NUCLEI"
