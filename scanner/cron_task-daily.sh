TSTAMP=$(date +%Y%m%d%H%M);
ls ~/SoC/scanner/data/ | grep '\-domain-' | \
while read TARGETFILE; do
    echo "$TSTAMP $TARGETFILE";
    docker run \
	--network "SOCnet" \
        --name "info-$TSTAMP-$TARGETFILE" \
        --volume ~/SoC/scanner/data/$TARGETFILE:/tmp/targets-domain.txt \
        -d \
	--memory="2g" \
	--cpus="1" \
        --env-file ~/SoC/scanner/.env \
        scanner:latest ./scanner-basic.sh;
done

ls ~/SoC/scanner/data/ | grep '\-ips-' | \
while read TARGETFILE; do
    echo "$TSTAMP $TARGETFILE";
    docker run \
	--network "SOCnet" \
        --name "info-$TSTAMP-$TARGETFILE" \
        --volume ~/SoC/scanner/data/$TARGETFILE:/tmp/targets-domain.txt \
        -d \
	--memory="2g" \
	--cpus="1" \
        --env-file ~/SoC/scanner/.env \
        scanner:latest ./scanner-IP-basic.sh;
done
