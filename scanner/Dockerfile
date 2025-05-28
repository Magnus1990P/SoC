FROM nixos/nix

RUN mkdir /scanning

WORKDIR /scanning

RUN nix-channel --update && \
	nix-env --install jq curl gawk && \
	nix-env --install ruby perl python3 go chromium && \
	nix-env --install dnsx tlsx subfinder naabu nuclei 

ADD ./*.sh ./
