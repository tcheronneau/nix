{
  description = "My personal nix packages";
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
  };
  outputs = { self, nixpkgs }:
  let
    system = "x86_64-linux";
    armpkgs = import nixpkgs {
      inherit system;
      crossSystem = {
        config = "aarch64-linux";
      };
    };
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
      sonarr = callPackage ./sonarr {};
      radarr = callPackage ./radarr {};
      plex = callPackage ./plex {};
      jackett = callPackage ./jackett {};
      bazarr = callPackage ./bazarr {};
      arm-sonarr = armpkgs.callPackage ./sonarr {};
      prowlarr = callPackage ./prowlarr {};
      ombi = callPackage ./ombi {};
      tautulli = python3Packages.callPackage ./tautulli {};
      docker-base-latest = callPackage ./docker {} ;
      docker-base-debug = callPackage ./docker/debug.nix {} ;
      docker-sonarr = callPackage ./sonarr/docker.nix { inherit docker-base-latest docker-base-debug ; } ;
      docker-prowlarr = callPackage ./prowlarr/docker.nix {} ;
      docker-jackett = callPackage ./jackett/docker.nix {} ;
      docker-radarr = callPackage ./radarr/docker.nix {} ;
      docker-tautulli = callPackage ./tautulli/docker.nix {} ;
      docker-ombi = callPackage ./ombi/docker.nix {} ;
    };
  };
}
