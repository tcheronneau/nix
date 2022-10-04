#{ pkgs ? import (builtins.fetchGit { name = "unstable"; url = "https://github.com/NixOS/nixpkgs"; rev = "21de2b973f9fee595a7a1ac4693efff791245c34";})> {} }:
{ pkgs ? import <nixpkgs-unstable> {} }:
rec {
    nvim = pkgs.callPackage ./nvim {};
    scripts = pkgs.callPackage ./mybash {};
    enpass = pkgs.callPackage ./enpass {};
    sonarr = pkgs.callPackage ./sonarr {};
    jackett = pkgs.callPackage ./jackett {};
    seafile = pkgs.callPackage ./seafile {};
    docker-sonarr = pkgs.callPackage ./sonarr/docker.nix {};
    docker-jackett = pkgs.callPackage ./jackett/docker.nix {};
}
