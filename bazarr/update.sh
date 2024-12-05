#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused nix-prefetch gawk jq
dirname=$(dirname "$0")
LAST=$(curl https://api.github.com/repos/morpheus65535/bazarr/releases/latest|jq -r ".tag_name")
latestVersion="$(expr $LAST : 'v\(.*\)')"
version=${VERSION:-$latestVersion}
url="https://github.com/morpheus65535/bazarr/releases/download/v${version}/bazarr.zip";

hash=$(nix-prefetch-url --type sha256 $url)
sriHash="$(nix hash convert --hash-algo sha256 --to sri $hash)"
sed -i "s|sha256 = \"[a-zA-Z0-9\/+-=]*\";|sha256 = \"$sriHash\";|g" ${dirname}/default.nix
sed -i "s/version = \"[0-9a-z.-]*\";/version = \"$version\";/g" "$dirname/default.nix"


echo "VERSION $version"
