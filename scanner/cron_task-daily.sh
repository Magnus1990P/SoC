#!/usr/bin/env sh

parallel --timeout 18000 -j3 docker run --rm --network "SOCnet" --volume {}:/tmp/targets-domain.txt --cpus 2 --memory "4G" --env-file ~/SoC/scanner/.env scanner:latest ./scanner-IP-basic.sh ::: ~/SoC/scanner/data/*-ips-*
parallel --timeout 18000 -j3 docker run --rm --network "SOCnet" --volume {}:/tmp/targets-domain.txt --cpus 2 --memory "4G" --env-file ~/SoC/scanner/.env scanner:latest ./scanner-basic.sh ::: ~/SoC/scanner/data/*-domain-*
