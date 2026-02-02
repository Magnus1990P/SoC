#!/usr/bin/env sh

parallel --timeout 18000 -j3 docker run --rm --network "SOCnet" \
	--env-file ~/SoC/scanner/.env scanner:latest \
	--volume ~/SoC/scanner/config/tmp/portlist-1000.txt:/tmp/portlist.txt \
	--volume {}:/tmp/targets-domain.txt \
	--cpus 2 --memory "4G" \
    ./scanner-IP-basic.sh ::: ~/SoC/scanner/data/*-ips-*

parallel --timeout 18000 -j3 docker run --rm --network "SOCnet" \
	--env-file ~/SoC/scanner/.env scanner:latest \
	--volume ~/SoC/scanner/config/tmp/portlist-1000.txt:/tmp/portlist.txt \
	--volume {}:/tmp/targets-domain.txt \
	--cpus 2 --memory "4G" \
    ./scanner-host-basic.sh ::: ~/SoC/scanner/data/*-domain-*
