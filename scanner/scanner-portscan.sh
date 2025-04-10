#!/usr/bin/bash
OSURL="$1"
OSUSER="$2"
OSPASSWD="$3"

OUT_NAABU="./data/OUTPUT-naabu.jsonl"
rm -f "$OUT_NAABU"

TF_NUCLEI="./config/targets-services.txt"
echo -n "" > $TF_NUCLEI

docker compose run --remove-orphans -it naabu

cat "$OUT_NAABU" | grep -v '^null:' | \
while read -r JSON; do
	IDENTIFIER=$(echo "$JSON" | md5sum | awk '{print $1}');
	if [[ -z "$JSON" ]]; then
		echo "$IDENTIFIER - $TARGET - NO DETECTIONS";
	else 
		HNAME=$(jq -r '.host' <<< "$JSON")
		IP=$(jq -r '.ip' <<< "$JSON")
		PORT=$(jq -r '.port' <<< "$JSON")
		curl -u "$OSUSER:$OSPASSWD" -k -XPOST "$OSURL/scan-port/_doc/$IDENTIFIER" --json "$JSON" --silent 1>/dev/null
		echo "$HNAME:$PORT" >> $TF_NUCLEI
		echo "$IP:$PORT" >> $TF_NUCLEI
		echo "PORT DISCOVERED: $HNAME - $IP - $PORT";
	fi
done;

cat "$TF_NUCLEI" | grep -v '^null:' | sort | uniq > .tmp
mv .tmp "$TF_NUCLEI"
