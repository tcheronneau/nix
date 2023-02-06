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
      flaresolverr = python3Packages.callPackage ./flaresolverr.nix {};
      prowlarr = callPackage ./prowlarr {};
      ombi = callPackage ./ombi {};
      tautulli = python3Packages.callPackage ./tautulli {};
      seafile = callPackage ./seafile {};
      kubeshark = callPackage ./kubeshark {} ;
      docker-base = callPackage ./docker {} ;
      docker-base-debug = callPackage ./docker/debug.nix {} ;
      docker-sonarr = callPackage ./sonarr/docker.nix {} ;
      docker-prowlarr = callPackage ./prowlarr/docker.nix {} ;
      docker-jackett = callPackage ./jackett/docker.nix {} ;
      docker-radarr = callPackage ./radarr/docker.nix {} ;
      docker-tautulli = callPackage ./tautulli/docker.nix {} ;
      docker-ombi = callPackage ./ombi/docker.nix {} ;
    };
  };
}
