#!/usr/bin/env bash

podman image trust set -t reject default
podman image trust set --type accept registry.mcth.fr

echo -n $CI_REGISTRY_PASSWORD | podman login -u $CI_REGISTRY_USER --password-stdin $CI_REGISTRY

podman load < $(nix-build -E 'with import <nixos-unstable> {}; callPackage ./docker.nix {}')
podman tag ${CI_REGISTRY_IMAGE}:nix ${CI_REGISTRY_IMAGE}:${VERSION}
podman push ${CI_REGISTRY_IMAGE}:${VERSION}
