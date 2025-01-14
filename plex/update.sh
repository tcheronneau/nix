#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused nix-prefetch gawk stdenv jq
dirname=$(dirname "$0")
token=$(cat ${dirname}/.token)
version=$(curl -H "X-Plex-Token:${token}" -s https://plex.tv/api/downloads/5.json?channel=plexpass|jq -r '.computer.Linux.version')
#version=${VERSION}

updateHash()
{
    version=$1
    arch=$2
    url="https://downloads.plex.tv/plex-media-server-new/${version}/debian/plexmediaserver_${version}_amd64.deb";
    n=2
    if [ "$arch" == "arm64" ]
    then
      n=1
      url="https://downloads.plex.tv/plex-media-server-new/${version}/debian/plexmediaserver_${version}_arm64.deb";
    fi
    hash=$(nix-prefetch-url --type sha256 $url)
    sriHash="$(nix hash convert --hash-algo sha256 --to sri $hash)"
    awk -i inplace -v sriHash="$sriHash" -v n=$n '/hash =/ {if (++count == n) sub(/hash = "[a-zA-Z0-9\/+-=]*"/,"hash = \""sriHash"\""); } 1' $dirname/raw.nix

}


updateHash $version arm64
updateHash $version x64
echo "VERSION $version"
sed -i "s/version = \"[0-9a-z.-]*\";/version = \"$version\";/g" "$dirname/raw.nix"
