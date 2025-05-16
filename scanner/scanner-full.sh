#!/usr/bin/env bash

###################################################
##  DNSX scan
./scanner-dns.sh
##
##  HOST enumeration scan
./scanner-host_enum.sh
##
##  TLSORT SCAN
./scanner-tls.sh
###################################################
##  PORT SCAN
./scanner-port.sh
###################################################
##  NUCLEI TEMPLATES
nuclei-templates --update
###################################################
##  NUCLEI SCAN
nuclei
