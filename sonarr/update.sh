#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq common-updater-scripts


update-source-version sonarr "$VERSION"
