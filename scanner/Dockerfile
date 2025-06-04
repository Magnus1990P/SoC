FROM nixos/nix:latest

RUN mkdir /scanning

WORKDIR /scanning

RUN nix-channel --update
RUN nix-env --install jq curl gawk git
RUN nix-env --install ruby perl python3 go
RUN nix-env --install dnsx tlsx subfinder naabu nuclei

RUN git clone "https://github.com/projectdiscovery/nuclei-templates.git" "/tmp/nuclei-templates"

ADD ./*.sh ./
