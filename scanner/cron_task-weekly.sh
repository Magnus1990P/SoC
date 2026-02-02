#!/usr/bin/env sh

parallel --timeout 86400 -j2 docker run --rm --network "SOCnet" \
    --env-file ~/SoC/scanner/.env scanner:latest \
    --volume ~/SoC/scanner/config/tmp/portlist-1000.txt:/tmp/portlist.txt \
    --volume {}:/tmp/targets-domain.txt \
    --cpus 4 --memory "6G" \
    ./scanner-IP-vuln.sh ::: ~/SoC/scanner/data/*-ips-*

#parallel --timeout 86400 -j2 docker run --rm --network "SOCnet" \
#    --env-file ~/SoC/scanner/.env \
#    --volume ~/SoC/scanner/config/tmp/portlist-1000.txt:/tmp/portlist.txt \
#    --volume {}:/tmp/targets-domain.txt \
#    --cpus 4 --memory "6G" scanner:latest \
#    ./scanner-host-vuln.sh ::: ~/SoC/scanner/data/*-domain-*
