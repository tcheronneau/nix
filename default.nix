{ pkgs? import <nixpkgs-unstable> {} }:
#{ callPackage }:
with pkgs;
rec {
    nvim = callPackage ./nvim {};
    scripts = callPackage ./mybash {};
    enpass = callPackage ./enpass {};
    sonarr = callPackage ./sonarr {};
    jackett = callPackage ./jackett {};
    bazarr = callPackage ./bazarr {};
    tautulli = callPackage ./tautulli {};
    plex = callPackage ./plex {};
    seafile = callPackage ./seafile {};
    kubernetes = callPackage ./kubernetes {};
    docker-sonarr = callPackage ./sonarr/docker.nix {};
    docker-jackett = callPackage ./jackett/docker.nix {};
}
