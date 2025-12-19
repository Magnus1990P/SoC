#!/usr/bin/env sh

parallel --timeout 86400 -j2 docker run --rm --network "SOCnet" --volume {}:/tmp/targets-domain.txt --cpus 4 --memory "6G" --env-file ~/SoC/scanner/.env scanner:latest ./scanner-IP-vuln.sh ::: ~/SoC/scanner/data/*-ips-*
#parallel --timeout 86400 -j2 docker run --rm --network "SOCnet" --volume {}:/tmp/targets-domain.txt --cpus 4 --memory "6G" --env-file ~/SoC/scanner/.env scanner:latest ./scanner-vuln-scan.sh ::: ~/SoC/scanner/data/*-domain-*
