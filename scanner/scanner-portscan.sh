#!/usr/bin/bash
OSURL="$1"
OSUSER="$2"
OSPASSWD="$3"

TF_NAABU="./temp-naabu-targets.txt"
TF_NUCLEI="./temp-nuclei-targets.txt"
TF_DNS="./resolvers.txt"

echo -n "" > $TF_NUCLEI

############################
##	PORT SCAN
NAABU_OUTPUTFILE="./OUTPUT-nuclei.jsonl"
sudo ./naabu -silent -json -c 500 -rate 3000 -retries 1 -sa -wn -cdn -tp 1000 \
	-list "$TF_NAABU" \
 	-r "$TF_DNS" -o "$NAABU_OUTPUTFILE"| \
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
