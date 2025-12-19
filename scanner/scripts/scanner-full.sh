#!/usr/bin/env bash

cat banner.txt


###################################################
##  DNSX scan
./part-scanner-dns.sh

###################################################
##  HOST enumeration scan
./part-scanner-host_enum.sh

###################################################
##  TLS SCAN
./part-scanner-tls.sh

###################################################
##  PORT SCAN
./part-scanner-port.sh

###################################################
##  NUCLEI SCAN
./part-scanner-vuln.sh

