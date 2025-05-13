#!/usr/bin/env bash
OSURL="$1"
OSUSER="$2"
OSPASSWD="$3"

###################################################
##  DNSX scan
###################################################
OUT_DNSX="/tmp/OUTPUT-dnsx.jsonl"
rm -f "$OUT_DNSX"

dnsx

cat "$OUT_DNSX" | \
while read -r JSON; do 
	IDENTIFIER=$(echo "$JSON" | md5sum | awk '{print $1}');
	if [[ -z "$JSON" ]]; then
		echo "$IDENTIFIER - $TARGET - NO DETECTIONS";
	else
		HNAME=$(jq -r '.host' <<< "$JSON")
		curl -u "$OSUSER:$OSPASSWD" -k -XPOST "$OSURL/scan-dnsx/_doc/$IDENTIFIER" --json "$JSON" --silent 1>/dev/null
		echo "DNSX DISCOVERED: $HNAME";
	fi
done;
