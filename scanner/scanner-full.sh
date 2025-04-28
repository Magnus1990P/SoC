#!/usr/bin/env bash

# PARAMETERS
OSURL="$1"
OSUSER="$2"
OSPASSWD="$3"

# WORKINGDIR
cd "$4"

## VARIABLE CONFIG
TF_SUBFINDER="./config/targets-domain.txt"
TF_NAABU="./config/targets-hosts.txt"
TF_NUCLEI="./config/targets-services.txt"

OUT_DNSX="./data/OUTPUT-dnsx.jsonl"
OUT_SUBFINDER="./data/OUTPUT-subfinder.jsonl"
OUT_NAABU="./data/OUTPUT-naabu.jsonl"

## FILE CLEANUP
rm -f "$OUT_DNS"
rm -f "$OUT_SUBFINDER"
rm -f "$OUT_NAABU"
echo -n "" > $TF_NUCLEI


###################################################
##  DNSX scan
###################################################
docker compose run --remove-orphans -it dnsx

cat "$OUT_DNSX" | \
while read -r JSON; do 
	IDENTIFIER=$(echo "$JSON" | md5sum | awk '{print $1}');
	if [[ -z "$JSON" ]]; then
		echo "$IDENTIFIER - $TARGET - NO DETECTIONS";
	else
		HNAME=$(jq -r '.host' <<< "$JSON")
		curl -u "$OSUSER:$OSPASSWD" -k -XPOST "$OSURL/scan-dnsx/_doc/$IDENTIFIER" --json "$JSON" --silent 1>/dev/null
		echo "DNST DISCOVERED: $HNAME";
	fi
done;


###################################################
##  HOST enumeration scan
###################################################
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
		curl -u "$OSUSER:$OSPASSWD" -k -XPOST "$OSURL/scan-dns/_doc/$IDENTIFIER" --json "$JSON" --silent 1>/dev/null
		echo "$HNAME" >> $TF_NAABU
		echo "HOST DISCOVERED: $HNAME";
	fi
done;

cat "$TF_SUBFINDER" "$TF_NAABU" | grep -v '^null:' | sort | uniq > .tmp
mv .tmp "$TF_NAABU"


###################################################
##  PORT SCAN
###################################################
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


###################################################
##  NUCLEI SCAN
###################################################
docker compose run --remove-orphans --rm -it nuclei
