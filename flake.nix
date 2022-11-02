{
  description = "My personal Neovim configuration";
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
  };
  outputs = { self, nixpkgs }:
  let 
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
  in
  {
    packages.${system} = with pkgs; rec {
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
    };
  };
}
