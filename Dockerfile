FROM nixos/nix
ARG APP

COPY $PWD /build
WORKDIR /build

RUN nix --experimental-features 'nix-command flakes' build .#${APP}
