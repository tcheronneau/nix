#!/usr/bin/env nix-shell 
#!nix-shell -i bash 

SOFTS=( "plex" "sonarr" "radarr" )

echo "##############################"
echo "Checking updates on : ${SOFTS[@]}"
echo "##############################"

for SOFT in ${SOFTS[@]}
do 
  echo "Checking update on ${SOFT}"
  echo ""
  echo "------------------------------"
  echo ""
  VERSION=$(./${SOFT}/update.sh|awk '/VERSION/ {print $2;}')
  if [ -f "${SOFT}/docker.nix" ]
  then 
    nix build .\#docker-${SOFT}
    docker load < $(readlink ./result)
    docker tag mcth/${SOFT}:nix mcth/${SOFT}:latest
    docker tag mcth/${SOFT}:nix mcth/${SOFT}:${VERSION}
  fi
done
echo "##############################"
echo "END"
echo "##############################"
