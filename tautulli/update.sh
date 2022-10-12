#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused nix-prefetch gawk
dirname=$(dirname "$0")
version=${VERSION}
url="https://github.com/Tautulli/Tautulli/archive/refs/tags/v${version}.zip"

hash=$(nix-prefetch-url --type sha256 $url)
sriHash="$(nix hash to-sri --type sha256 $hash)"
echo $sriHash
sed -i "s|sha256 = \"[a-zA-Z0-9\/+-=]*\";|sha256 = \"$sriHash\";|g" ${dirname}/default.nix
sed -i "s/version = \"[0-9.]*\";/version = \"$version\";/g" "$dirname/default.nix"
