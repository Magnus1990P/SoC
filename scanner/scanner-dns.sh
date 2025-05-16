#!/usr/bin/env bash

###################################################
##  DNSX scan
###################################################
OUT_DNSX="/tmp/OUTPUT-dnsx.jsonl"

dnsx

cat "$OUT_DNSX" | \
while read -r JSON; do 
	IDENTIFIER=$(echo "$JSON" | md5sum | awk '{print $1}');
	if [[ -z "$JSON" ]]; then
		echo "$IDENTIFIER - $TARGET - NO DETECTIONS";
	else
		HNAME=$(jq -r '.host' <<< "$JSON")
		curl -u "$OPENSEARCH_USER:$OPENSEARCH_PASSWORD" -k -XPOST "$OPENSEARCH_URL/scan-dnsx/_doc/$IDENTIFIER" --json "$JSON" --silent 1>/dev/null
		echo "DNSX DISCOVERED: $HNAME";
	fi
done;
