{
  description = "My personal Neovim configuration";
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
  };
  outputs = { self, nixpkgs }:
  let 
    system = "x86_64-linux";
    pkgs = import nixpkgs { 
      inherit system; 
      config.allowUnfree = true;
      overlays = [
        (final: prev: {
          plexRaw = final.callPackage ./plex/raw.nix {};
        })
      ];
    };
  in
  {
    packages.${system} = with pkgs; rec {
      nvim = callPackage ./nvim {};
      scripts = callPackage ./mybash {};
      enpass = callPackage ./enpass {};
      sonarr = callPackage ./sonarr {};
      radarr = callPackage ./radarr {};
      plex = callPackage ./plex {};
      jackett = callPackage ./jackett {};
      bazarr = callPackage ./bazarr {};
      tautulli = python3Packages.callPackage ./tautulli {};
      seafile = callPackage ./seafile {};
    };
  };
}
