#!/usr/bin/env bash

cat banner.txt


###################################################
##  HOST enumeration scan
./part-scanner-host_enum.sh

###################################################
##  PORT SCAN
./part-scanner-port.sh

###################################################
##  NUCLEI SCAN
./part-scanner-vuln.sh