#{ pkgs? import ./source.nix {} }:

#with pkgs;
{
  self,
  ...
} @ inputs: let
  pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
in 
  with pkgs; {
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
    docker-sonarr = callPackage ./sonarr/docker.nix {};
    docker-jackett = callPackage ./jackett/docker.nix {};
  }
