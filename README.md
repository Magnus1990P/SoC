# SoC
SoC based on OpenSearch and project discovery tools


## OpenSearch
Single node docker compose with environment file to set admin password and data store

Start with: `docker compose up -d`


## scanner
Configuration and dockerfile for creating a scanning image which takes a custom configs and a target file with domains to extrapolate and scan.
It runs
1. dnsx -  for dns information on the target domain only
1. subfinder - Host enumeration of the target domains
1. tlsx - TLS scan of the enumerated domains and target domains
1. naabu - Port scan of the enumerated hosts and target domains
1. nuclei - Vulnerability and information gathering on the enumerated ports for each host.

The results are uploaded to an Elasict/OpenSearch instance for management using custom dashboards.  
TODO: add dasboards and visualizations

To run a scan build said image using: `docker compose build`

Alter configuration files, particularly nuclei-reporting.yaml.sample, and add your OpenSearch credentials to the .env file.

Run said image with path to domain target list:
* `TARGET_FILE=[LOCAL_PATH] docker compose run scanner`
* `docker compose up -d`
    - With the environment variable specified in the .env
    - Omittance of enviroment variables will load the sample files.


## Cron job
Set up crontab as follows after configuring parameters and building the Docker image
```
45 00,06,16 * * *   localadmin    bash ~/SoC/scanner/cron_task.sh >> /tmp/scan.log
```
