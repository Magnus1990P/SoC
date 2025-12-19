#!/usr/bin/env bash

cat banner.txt

cp /tmp/targets-domain.txt "/tmp/targets-hosts.txt"
cp /tmp/targets-domain.txt "/tmp/targets-ips.txt"

###################################################
##  TLS SCAN
./part-scanner-tls.sh

###################################################
##  PORT SCAN
./part-scanner-port.sh

###################################################
##  NUCLEI SCAN
./part-scanner-vuln.sh