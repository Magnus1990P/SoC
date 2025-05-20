#!/usr/bin/env bash

OUT_TLSX="/tmp/OUTPUT-tlsx.jsonl"

tlsx

cat "$OUT_TLSX" | while read -r JSON; do 
	IDENTIFIER=$(echo "$JSON" | md5sum | awk '{print $1}');
	if [[ -z "$JSON" ]]; then
		echo "$IDENTIFIER - $TARGET - NO DETECTIONS";
	else
		HNAME=$(jq -r '.host' <<< "$JSON")
		curl -u "$OPENSEARCH_USER:$OPENSEARCH_PASSWORD" -k -XPOST "$OPENSEARCH_URL/scan-tlsx/_doc/$IDENTIFIER" --json "$JSON" --silent 1>/dev/null
		echo "TLS SCANNED: $HNAME";
	fi
done;
