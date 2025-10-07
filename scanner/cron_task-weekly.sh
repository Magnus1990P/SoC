TSTAMP=$(date +%Y%m%d%H%M);

#ls ~/SoC/scanner/data/ | grep '\-domain-' | \
#while read TARGETFILE; do
#    echo "$TSTAMP $TARGETFILE";
#    docker run \
#	--network "SOCnet" \
#        --name "vuln-$TSTAMP-$TARGETFILE" \
#        --volume ~/SoC/scanner/data/$TARGETFILE:/tmp/targets-domain.txt \
#        -d \
#        --env-file ~/SoC/scanner/.env \
#        scanner:latest ./scanner-security.sh;
#done

ls ~/SoC/scanner/data/ | grep '\-ips-' | \
while read TARGETFILE; do
    echo "$TSTAMP $TARGETFILE";
    docker run \
	--network "SOCnet" \
        --name "vuln-$TSTAMP-$TARGETFILE" \
        --volume ~/SoC/scanner/data/$TARGETFILE:/tmp/targets-domain.txt \
        -d \
	--memory="3g" \
	--cpus="4" \
        --env-file ~/SoC/scanner/.env \
        scanner:latest ./scanner-IP-vuln.sh;
done
