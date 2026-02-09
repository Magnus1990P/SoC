#!/usr/bin/env python3

import json
import xml.etree.ElementTree as ET
from datetime import datetime

tree = ET.parse("/tmp/OUTPUT-nmap.xml")
root = tree.getroot()

timestamp = datetime.strftime(datetime.now(), "%Y-%m-%dT%H:%M:%S%z")

for host in root.iter("host"):
    address = host.find("address").attrib["addr"]
    hostnames = [element.attrib["name"] for element in host.find("hostnames").iter("hostname")]

    for port in host.iter("port"):
        protocol = port.attrib["protocol"]
        portnum = int(port.attrib["portid"], 10)
        service = port.find("service").attrib["name"]

        if hostnames:
            for hostname in hostnames:
                print(json.dumps({"@timestamp": timestamp.__str__(), "timestamp": timestamp.__str__(),
                                  "ip":address, "host": hostname, 
                                  "protocol": protocol, "port": portnum, "tls": None, "service": service}))   
        else:
            print(json.dumps({"@timestamp": timestamp.__str__(), "timestamp": timestamp.__str__(), 
                              "ip":address, "host": None,  
                              "protocol": protocol, "port": portnum, "tls": None, "service": service}))
