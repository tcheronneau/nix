#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/nixpkgs-unstable.tar.gz -i bash -p curl jq common-updater-scripts 
set -eo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
LAST=$(curl -s https://api.github.com/repos/jackett/jackett/tags|jq -r '.[0].name'|sed "s/v//g")
VERSION=${VERSION:-$LAST}

deps_file="$(realpath "./deps.nix")"

cd ..
update-source-version jackett "${VERSION//v}"
$(nix-build -A jackett.fetch-deps --no-out-link) "$deps_file"
echo "VERSION ${VERSION}"
