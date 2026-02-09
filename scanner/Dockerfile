FROM nixos/nix:latest

RUN mkdir /scanning

WORKDIR /scanning

ENV TARGET_FILE="/tmp/targets-domain.txt"

RUN nix-channel --update && \
    nix-env --install jq curl gawk git-minimal openssl \
                ruby perl python3-minimal go \
                dnsx tlsx subfinder naabu nuclei \
                nmap

ADD ./config-default/root_dot_config/  /root/.config/
ADD ./config/root_dot_config/  /root/.config/

ADD ./config-default/tmp/  /tmp/
ADD ./config/tmp/ /tmp/

ADD ./scripts ./
