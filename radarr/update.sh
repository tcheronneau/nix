#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused nix-prefetch jq

set -e

dirname="$(dirname "$0")"
LAST=$(curl -s https://api.github.com/repos/radarr/radarr/tags|jq -r '.[0].name'|sed "s/v//g")
VERSION=${VERSION:-$LAST}

updateHash()
{
    version=$1
    arch=$2
    os=$3

    hashKey="${arch}-${os}_hash"

    url="https://github.com/Radarr/Radarr/releases/download/v$version/Radarr.develop.$version.$os-core-$arch.tar.gz"
    hash=$(nix-prefetch-url --type sha256 $url)
    sriHash="$(nix hash to-sri --type sha256 $hash)"

    sed -i "s|$hashKey = \"[a-zA-Z0-9\/+-=]*\";|$hashKey = \"$sriHash\";|g" "$dirname/default.nix"
}

updateVersion()
{
    sed -i "s/version = \"[0-9.]*\";/version = \"$1\";/g" "$dirname/default.nix"
}


updateVersion $VERSION

updateHash $VERSION x64 linux
updateHash $VERSION arm64 linux
updateHash $VERSION x64 osx
