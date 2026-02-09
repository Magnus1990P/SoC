#!/usr/bin/env bash

OSIndex=scan-port
OSIndex=testbed

TF_NUCLEI="/tmp/targets-hosts.txt"

###################################
##	PORT SCANNING WITH NMAP
##
TARGETFILE=/tmp/targets-ips.txt
PORTS_TCP=/tmp/portlist-tcp.txt
PORTS_UDP=/tmp/portlist-udp.txt
nmap -Pn -sU -sT --open \
	--host-timeout 15m --max-rtt-timeout 2500ms \
	--max-retries 0 --min-rate 250 --max-rate 2000 \
	-iL "$TARGETFILE" \
	-p "T:$(paste -d, -s $PORTS_TCP),U:$(paste -d, -s $PORTS_UDP)" \
	-oX "/tmp/OUTPUT-nmap.xml"


python3 ./parser-nmap-xml.py | while read -r JSON; do 
	IDENTIFIER=$(echo "$JSON" | md5sum | awk '{print $1}');
	if [[ -z "$JSON" ]]; then
		echo "$IDENTIFIER - NO DETECTIONS";
	else
		IP=$(jq -r '.ip' <<< "$JSON")
		PORT=$(jq -r '.port' <<< "$JSON")
		PROT=$(jq -r '.protocol' <<< "$JSON")
		HOST=$(jq -r '.host' <<< "$JSON")

		echo $JSON

		curl -u "$OPENSEARCH_USER:$OPENSEARCH_PASSWORD" -k -XPOST "$OPENSEARCH_URL/$OSIndex/_doc/$IDENTIFIER" --json "$JSON" #--silent 1>/dev/null
		
		echo "OPEN PORT: $IP : $PROT/$PORT"
		echo "$IP:$PORT" >> $TF_NUCLEI
		if [[ "$HOST" != "None" ]]; then
			echo "$HOST:$PORT" >> $TF_NUCLEI
		fi
	fi
done;

cat   $TF_NUCLEI

###################################
##	GENERATE NUCLEI FILE
##
if [[ -s "$TF_NUCLEI" ]]; then
	cat "$TF_NUCLEI" | grep -v "^null" | sort | uniq >> "$TF_NUCLEI.tmp"
	mv "$TF_NUCLEI.tmp" "$TF_NUCLEI"
fi
