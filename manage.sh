#!/usr/bin/env nix-shell 
#!nix-shell -i bash 

if [ -z $1 ]
then
  SOFTS=( "plex" "sonarr" "radarr" "tautulli" "jackett" )
else
  SOFTS=$1
fi

echo "##############################"
echo "Checking updates on : ${SOFTS[@]}"
echo "##############################"

NS="media"
for SOFT in ${SOFTS[@]}
do 
  echo "Checking update on ${SOFT}"
  echo ""
  echo "------------------------------"
  echo ""
  VERSION=$(./${SOFT}/update.sh|awk '/VERSION/ {print $2;}')
  if [[ `git status --porcelain` ]]
  then
    if [ -f "${SOFT}/docker.nix" ]
    then 
      echo "Building docker for ${SOFT} on version: ${VERSION}"
      nix build .\#docker-${SOFT}
      docker load < $(readlink ./result)
      docker tag mcth/${SOFT}:nix mcth/${SOFT}:latest
      docker tag mcth/${SOFT}:nix mcth/${SOFT}:${VERSION}
      docker push mcth/${SOFT}
      docker push mcth/${SOFT}:${VERSION}
      kubectl set image "deploy/${SOFT}" -n "${NS}" "${SOFT}=mcth/${SOFT}:${VERSION:-latest}"
      git commit -am "Update ${SOFT} with new version : ${VERSION}"
      git push
    fi
  fi
done
#echo "##############################"
#echo "END"
#echo "##############################"
