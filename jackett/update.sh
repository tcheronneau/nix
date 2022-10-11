#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/nixpkgs-unstable.tar.gz -i bash -p curl jq common-updater-scripts 
set -eo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

deps_file="$(realpath "./deps.nix")"

cd ..
update-source-version jackett "${VERSION//v}"
$(nix-build -A jackett.fetch-deps --no-out-link) "$deps_file"
