#!/usr/bin/env bash


###################################################
##  Get Templates
echo ""
echo "%%%%%%%%%%%%%%%%%%%%%%"
git clone --quiet --depth 1 https://github.com/projectdiscovery/nuclei-templates.git /tmp/nuclei-templates
echo "%%%%%%%%%%%%%%%%%%%%%%"
echo ""


###################################################
##  Vulnerability scan
nuclei
