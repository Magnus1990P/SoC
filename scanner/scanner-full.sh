#!/usr/bin/env bash

# PARAMETERS
OSURL="$1"
OSUSER="$2"
OSPASSWD="$3"

# WORKINGDIR
WORKINGDIR="$4"
cd "$WORKINGDIR"

###################################################
##  DNSX scan
./scanner-dns.sh "$OSURL" "$OSUSER" "$OSPASSWD" 
##
##  HOST enumeration scan
./scanner-host_enum.sh "$OSURL" "$OSUSER" "$OSPASSWD"
##
##  TLSORT SCAN
./scanner-tls.sh "$OSURL" "$OSUSER" "$OSPASSWD" 
###################################################
##  PORT SCAN
./scanner-port.sh "$OSURL" "$OSUSER" "$OSPASSWD"
###################################################
##  NUCLEI SCAN
nuclei
