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
  ./${SOFT}/update.sh
  if [ -f "${SOFT}/docker.nix" ]
  then 
    podman load <$(nix build .\#docker-${SOFT})
  fi
done
echo "##############################"
echo "END"
echo "##############################"
