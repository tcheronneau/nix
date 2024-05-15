{ pkgs? import ./source.nix {config.allowUnfree=true;} }:
#{ callPackage }:
with pkgs;
rec {
    nvim = callPackage ./nvim {};
    scripts = callPackage ./mybash {};
    enpass = callPackage ./enpass {};
    sonarr = callPackage ./sonarr {};
    radarr = callPackage ./radarr {};
    jackett = callPackage ./jackett {};
    bazarr = callPackage ./bazarr {};
    tautulli = python3Packages.callPackage ./tautulli {};
    plex = callPackage ./plex {};
    seafile = callPackage ./seafile {};
    kubernetes = callPackage ./kubernetes {};
    docker-base-latest = callPackage ./docker {};
    docker-sonarr = callPackage ./sonarr/docker.nix {};
    docker-jackett = callPackage ./jackett/docker.nix {};
    kubeshark = callPackage ./kubeshark {} ;
}

