#!/usr/bin/bash

OSURL="$1"
OSUSER="$2"
OSPASSWD="$3"

TF_NAABU="./temp-naabu-targets.txt"
TF_NUCLEI="./temp-nuclei-targets.txt"
TF_DNS="./resolvers.txt"

echo -n "" > $TF_NAABU
echo -n "" > $TF_NUCLEI

./subfinder -silent \
	-dL "subfinder-domain_targets-active.txt" \
	-t 50 -rl 500 -timeout 3 \
	-recursive \
	-rL "$TF_DNS" \
	-nW -oI -oJ -o "./temp-subfinder-results.jsonl" | \
while read -r JSON; do
	IDENTIFIER=$(echo $JSON | md5sum | awk '{print $1}');
	echo $JSON
	if [[ -z "$JSON" ]]; then
		echo "$IDENTIFIER - $TARGET - NO DETECTIONS";
	else
		HNAME=$(jq -r '.host' <<< "$JSON")
		IP=$(jq -r '.ip' <<< "$JSON")
		curl -u "$OSUSER:$OSPASSWD" -k -XPOST "$OSURL/scan-host/_doc/$IDENTIFIER" --json "$JSON" --silent 1>/dev/null
		echo "$IP" >> $TF_NAABU
		echo "$HNAME" >> $TF_NAABU
		echo "$IDENTIFIER - $HNAME:$IP - LOGGED FINDING";
	fi
done;

sudo ./naabu -silent -json -l "$TF_NAABU" -config ./naabu-config.yaml -tp 100 | \
while read -r JSON; do
	echo "$JSON"
	IDENTIFIER=$(echo $JSON | md5sum | awk '{print $1}');
	if [[ -z "$JSON" ]]; then
		echo "$IDENTIFIER - $TARGET - NO DETECTIONS";
	else 
		HNAME=$(jq -r '.host' <<< "$JSON")
		IP=$(jq -r '.ip' <<< "$JSON")
		PORT=$(jq -r '.port' <<< "$JSON")
		curl -u "$OSUSER:$OSPASSWD" -k -XPOST "$OSURL/scan-port/_doc/$IDENTIFIER" --json "$JSON" --silent 1>/dev/null
		echo "$HNAME:$PORT" >> $TF_NUCLEI
		echo "$IP:$PORT" >> $TF_NUCLEI
		echo "$IDENTIFIER - $IP:$PORT - LOGGED FINDING";
	fi
done;

./nuclei -rc ./nuclei-reporting.yaml -config ./nuclei-scan_config.yaml -l "$TF_NUCLEI"
