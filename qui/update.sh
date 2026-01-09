#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused nix-prefetch jq

set -e

dirname="$(dirname "$0")"
echo $dirname

updateHash()
{
    version=$1
    arch=$2
    os=$3

    hashKey="${arch}-${os}_hash"

    url="https://github.com/autobrr/qui/releases/download/v${version}/qui_${version}_${os}_${arch}.tar.gz";
    hash=$(nix-prefetch-url --type sha256 $url)
    sriHash="$(nix hash convert --hash-algo sha256 --to sri $hash)"

    sed -i "s|$hashKey = \"[a-zA-Z0-9\/+-=]*\";|$hashKey = \"$sriHash\";|g" "$dirname/default.nix"
}

updateVersion()
{
    sed -i "s/version = \"[0-9.]*\";/version = \"$1\";/g" "$dirname/default.nix"
}

currentVersion=$(cat "$dirname/default.nix"|awk -F'"' '/version =/ {print $2;}')

latestTag=$(curl https://api.github.com/repos/autobrr/qui/releases/latest | jq -r ".tag_name")
latestVersion="$(expr $latestTag : 'v\(.*\)')"

if [[ "$currentVersion" == "$latestVersion" ]]; then
    echo "Qui is up-to-date: ${currentVersion}"
    exit 0
fi

updateVersion $latestVersion

updateHash $latestVersion x86_64 linux

echo "VERSION $latestVersion"
