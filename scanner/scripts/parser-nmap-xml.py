#!/usr/bin/env python3

import xml.etree.ElementTree as ET
from datetime import datetime
from zoneinfo import ZoneInfo

tree = ET.parse("../OUTPUT-nmap.xml")
root = tree.getroot()

timestamp = datetime.now(ZoneInfo("UTC"))

for host in root.iter("host"):
    address = host.find("address").attrib["addr"]
    hostnames = [element.attrib["name"] for element in host.find("hostnames").iter("hostname")]

    for port in host.iter("port"):
        protocol = port.attrib["protocol"]
        portnum = int(port.attrib["portid"], 10)
        service = port.find("service").attrib["name"]

        if hostnames:
            for hostname in hostnames:
                print({"@timestamp": timestamp.__str__(), "ip":address, "host": hostname, 
                       "protocol": protocol, "port": portnum, "service": service})
        else:
            print({"@timestamp": timestamp.__str__(), "ip":address, "host": None, 
                    "protocol": protocol, "port": portnum, "service": service})
