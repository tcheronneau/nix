{ pkgs ? import <nixpkgs> {} }:
rec {
    nvim = pkgs.callPackage ./nvim {};
    scripts = pkgs.callPackage ./mybash {};
    enpass = pkgs.callPackage ./enpass {};
    sonarr = pkgs.callPackage ./sonarr {};
    seafile = pkgs.callPackage ./seafile {};
    docker-sonarr = pkgs.callPackage ./sonarr/docker.nix {};
}
