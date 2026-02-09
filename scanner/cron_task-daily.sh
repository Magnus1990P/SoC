#!/usr/bin/env sh

parallel --timeout 18000 -j3 docker run --rm --network "SOCnet" \
	--env-file ~/SoC/scanner/.env --cpus 2 --memory "4G" \
	--ulimit memlock=-1:-1 --ulimit nofile:10000:10000 \
	--volume ~/SoC/scanner/config/tmp/portlist-1000.txt:/tmp/portlist.txt \
	--volume {}:/tmp/targets-domain.txt \
	scanner:latest ./scanner-IP-basic.sh ::: ~/SoC/scanner/data/*-ips-*

parallel --timeout 18000 -j3 docker run --rm --network "SOCnet" \
	--env-file ~/SoC/scanner/.env --cpus 2 --memory "4G" \
	--volume ~/SoC/scanner/config/tmp/portlist-1000.txt:/tmp/portlist.txt \
	--volume {}:/tmp/targets-domain.txt \
	scanner:latest ./scanner-host-basic.sh ::: ~/SoC/scanner/data/*-domain-*

