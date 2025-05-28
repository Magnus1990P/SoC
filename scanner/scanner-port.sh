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
		curl -u "$OPENSEARCH_USER:$OPENSEARCH_PASSWORD" -k -XPOST "$OPENSEARCH_URL/scan-port/_doc/$IDENTIFIER" --json "$JSON" --silent 1>/dev/null
		#echo "$HNAME:$PORT" >> $TF_NUCLEI
		#echo "$IP:$PORT" >> $TF_NUCLEI
		echo "$HNAME" >> $TF_NUCLEI
		echo "$IP" >> $TF_NUCLEI
		echo "PORT DISCOVERED: $HNAME - $IP - $PORT";
	fi
done;

cat "$TF_NUCLEI" | grep -v '^null:' | sort | uniq > "/tmp/.targets-services.txt"
mv "/tmp/.targets-services.txt" "$TF_NUCLEI"
