#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused nix-prefetch gawk common-updater-scripts
dirname=$(dirname "$0")
LAST=$(curl -s https://api.github.com/repos/tautulli/tautulli/tags|jq -r '.[0].name'|sed "s/v//g")
version=${VERSION:-$LAST}
update-source-version tautulli "${version//v}"
echo "VERSION ${version}"
#url="https://github.com/Tautulli/Tautulli/archive/refs/tags/v${version}.tar.gz"
#
#hash=$(nix-prefetch-url --type sha256 $url)
#sriHash="$(nix hash to-sri --type sha256 $hash)"
#sed -i "s|sha256 = \"[a-zA-Z0-9\/+-=]*\";|sha256 = \"$sriHash\";|g" ${dirname}/default.nix
#sed -i "s/version = \"[0-9.]*\";/version = \"$version\";/g" "$dirname/default.nix"
#echo $version
