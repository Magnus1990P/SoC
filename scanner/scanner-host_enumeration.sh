#!/usr/bin/bash
OSURL="$1"
OSUSER="$2"
OSPASSWD="$3"

SUBFINDER_TARGET_LIST="./subfinder-domain_targets-active.txt"

TF_NAABU="./temp-naabu-targets.txt"
TF_DNS="./resolvers.txt"

echo -n "" > $TF_NAABU

############################
##	HOST ENUMERATION
SUBFINDER_OUTPUTFILE="./OUTPUT-subfinder.jsonl"
./subfinder -silent \
	-dL "$SUBFINDER_TARGET_LIST" \
	-t 300 -rl 3000 -timeout 1 -recursive \
	-rL "$TF_DNS" \
	-nW -oI -oJ -o "$SUBFINDER_OUTPUTFILE" | \
while read -r JSON; do
	IDENTIFIER=$(echo "$JSON" | md5sum | awk '{print $1}');
	if [[ -z "$JSON" ]]; then
		echo "$IDENTIFIER - $TARGET - NO DETECTIONS";
	else
		HNAME=$(jq -r '.host' <<< "$JSON")
		IP=$(jq -r '.ip' <<< "$JSON")
		curl -u "$OSUSER:$OSPASSWD" -k -XPOST "$OSURL/scan-dns/_doc/$IDENTIFIER" --json "$JSON" --silent 1>/dev/null
		echo "$IP" >> $TF_NAABU
		echo "$HNAME" >> $TF_NAABU
		echo "HOST DISCOVERED: $HNAME - $IP";
	fi
done;
cat "$TF_NAABU" | grep -v '^null:' | sort | uniq > .tmp
mv .tmp "$TF_NAABU"
