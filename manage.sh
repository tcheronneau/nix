#!/usr/bin/env nix-shell 
#!nix-shell -i bash -p git gawk gnused kubectl curl docker openssh
DIR=$(dirname ${BASH_SOURCE[0]})
cd $DIR

echo $DIR
if [ -z $1 ]
then
  SOFTS=( "plex" "sonarr" "radarr" "tautulli" "prowlarr" "bazarr" )
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
  VERSION=$(${DIR}/${SOFT}/update.sh|awk '/VERSION/ {print $2;}')
  if [[ `git -C ${DIR} status --porcelain` ]]
  then
    if [ -f "${SOFT}/docker.nix" ]
    then 
      echo "Building docker for ${SOFT} on version: ${VERSION}"
      nix build .\#docker-${SOFT}
      docker load < $(readlink ${DIR}/result)
      docker tag mcth/${SOFT}:nix mcth/${SOFT}:latest
      docker tag mcth/${SOFT}:nix mcth/${SOFT}:${VERSION}
      docker push mcth/${SOFT}
      docker push mcth/${SOFT}:${VERSION}
      kubectl set image "deploy/${SOFT}" -n "${NS}" "${SOFT}=mcth/${SOFT}:${VERSION:-latest}"
    fi
    git -C $DIR pull
    git -C $DIR commit -am "Update ${SOFT} with new version : ${VERSION}"
    curl -XPOST -H 'Content-Type: application/json' https://rshook.mcth.eu/send -d '{"title": "'"${SOFT}"'", "message": "'"${VERSION}"'" }'
    git -C $DIR push
  fi
done
#echo "##############################"
#echo "END"
#echo "##############################"
