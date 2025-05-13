FROM nixos/nix

RUN mkdir /scanning

ENV OPENSEARCH_URL="https://localhost:9200"
ENV OPENSEARCH_USER="admin"
ENV OPENSEARCH_PASSWORD="CHANGE_ME" 

RUN nix-channel --update

WORKDIR /scanning

ADD ./*.sh ./

ADD ./config/dnsx-config.yaml.sample        /root/.config/dnsx/config.yaml

ADD ./config/nuclei-config.yaml.sample      /root/.config/config.yaml
ADD ./config/nuclei-reporting.yaml.sample   /root/.config/reporting.yaml

ADD ./config/subfinder-config.yaml.sample   /root/.config/config.yaml
ADD ./config/subfinder-provider.yaml.sample /root/.config/provider.yaml

ADD ./config/tlsx-config.yaml.sample /root/.config/tlsx/config.yaml

ADD ./config/hosts-exclude.txt.sample /tmp/hosts-exclude.txt
ADD ./config/ports-default.txt.sample /tmp/ports-default.txt
ADD ./config/ports-exclude.txt.sample /tmp/ports-exclude.txt
ADD ./config/resolvers-dns.txt.sample /tmp/resolvers-dns.txt

ADD ./config/targets-domain.txt.sample /tmp/targets-domain.txt

CMD nix-shell -p dnsx subfinder tlsx naabu nuclei nuclei-templates '<nixpkgs>' --run "./scanner-full.sh $OPENSEARCH_URL $OPENSEARCH_USER $OPENSEARCH_PASSWORD /scanning"
