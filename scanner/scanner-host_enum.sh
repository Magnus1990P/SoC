#!/usr/bin/env bash
OSURL="$1"
OSUSER="$2"
OSPASSWD="$3"

TF_SUBFINDER="./config/targets-domain.txt"
TF_NAABU="./config/targets-hosts.txt"
OUT_SUBFINDER="./data/OUTPUT-subfinder.jsonl"
rm -f "$OUT_SUBFINDER"

ts=$(date +"%Y-%m-%dT%H:%M:%S%z")
docker compose run --remove-orphans -it subfinder

cat "$OUT_SUBFINDER" | \
while read -r JSON; do 
	JSON=$(echo $JSON | jq ". += {\"timestamp\": \"$ts\", \"@timestamp\":\"$ts\"}")
	IDENTIFIER=$(echo "$JSON" | md5sum | awk '{print $1}');
	if [[ -z "$JSON" ]]; then
		echo "$IDENTIFIER - $TARGET - NO DETECTIONS";
	else
		HNAME=$(jq -r '.host' <<< "$JSON")
		curl -u "$OSUSER:$OSPASSWD" -k -XPOST "$OSURL/scan-host/_doc/$IDENTIFIER" --json "$JSON" --silent 1>/dev/null
		echo "$HNAME" >> $TF_NAABU
		echo "HOST DISCOVERED: $HNAME";
	fi
done;

cat "$TF_SUBFINDER" "$TF_NAABU" | grep -v '^null:' | sort | uniq > .tmp
mv .tmp "$TF_NAABU"

