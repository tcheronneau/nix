#!/usr/bin/env bash

podman image trust set -t accept default

echo -n $CI_REGISTRY_PASS | podman login -u abott --password-stdin $CI_REGISTRY

cd ${NAME}
podman load < $(nix-build -E 'with import <nixos-unstable> {}; callPackage ./docker.nix {}')
podman tag ${CI_REGISTRY}/docker/${NAME}:nix ${CI_REGISTRY}/docker/${NAME}:${VERSION}
podman push ${CI_REGISTRY}/docker/${NAME}:${VERSION}
