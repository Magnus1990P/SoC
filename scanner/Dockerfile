FROM nixos/nix:latest

RUN mkdir /scanning

WORKDIR /scanning

ENV TARGET_FILE="/tmp/targets-domain.txt"

RUN nix-channel --update
RUN nix-env --install jq curl gawk git
RUN nix-env --install ruby perl python3 go
RUN nix-env --install dnsx tlsx subfinder naabu nuclei

ADD ./config-default/root_dot_config/  /root/.config/
ADD ./config/root_dot_config/  /root/.config/

ADD ./config-default/tmp/  /tmp/
ADD ./config/tmp/ /tmp/

ADD ./scripts ./

ENTRYPOINT ["./scanner-full.sh"]
