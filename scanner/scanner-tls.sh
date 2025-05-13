#!/usr/bin/env bash
OSURL="$1"
OSUSER="$2"
OSPASSWD="$3"

OUT_TLSX="/tmp/OUTPUT-tlsx.jsonl"
rm -f "$OUT_TLSX"

tlsx

cat "$OUT_TLSX" | while read -r JSON; do 
	IDENTIFIER=$(echo "$JSON" | md5sum | awk '{print $1}');
	if [[ -z "$JSON" ]]; then
		echo "$IDENTIFIER - $TARGET - NO DETECTIONS";
	else
		HNAME=$(jq -r '.host' <<< "$JSON")
		curl -u "$OSUSER:$OSPASSWD" -k -XPOST "$OSURL/scan-tlsx/_doc/$IDENTIFIER" --json "$JSON" --silent 1>/dev/null
		echo "TLS SCANNED: $HNAME";
	fi
done;
