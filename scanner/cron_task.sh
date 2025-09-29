TSTAMP=$(date +%Y%m%d%H%M);
ls ~/SoC/scanner/data/ | grep '\-domain-' | \
while read TARGETFILE; do
    echo "$TSTAMP $TARGETFILE";
    docker run \
        --name "$TSTAMP-$TARGETFILE" \
        --volume ~/SoC/scanner/data/$TARGETFILE:/tmp/targets-domain.txt \
        -d \
        --env-file ~/SoC/scanner/.env \
        scanner:latest ./scanner-basic.sh;
done
