FROM nixos/nix

RUN mkdir /scanning

WORKDIR /scanning

RUN nix-channel --update

ADD ./*.sh ./
