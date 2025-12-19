#!/usr/bin/env bash


###################################################
##  Get Templates
echo ""
echo "%%%%%%%%%%%%%%%%%%%%%%"
git clone --depth 1 https://github.com/projectdiscovery/nuclei-templates.git /tmp/nuclei-templates

echo "%%%%%%%%%%%%%%%%%%%%%%"
echo "DISCOVERED HOSTS"
echo "%%%%%%%%%%%%%%%%%%%%%%"
cat /tmp/targets-hosts.txt
echo "%%%%%%%%%%%%%%%%%%%%%%"
echo ""

###################################################
##  Vulnerability scan
nuclei
