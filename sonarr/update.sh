#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq common-updater-scripts

LAST=$(curl -s https://services.sonarr.tv/v1/download/main|jq -r '.version')
#LAST=$(curl -s https://api.github.com/repos/sonarr/sonarr/tags|jq -r '.[0].name'|sed "s/v//g")
VERSION=${VERSION:-$LAST}
update-source-version sonarr "$VERSION"
echo "VERSION $VERSION"

