{
  description = "My personal Neovim configuration";
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
      beeper = callPackage ./beeper.nix {};
      gitbutler = callPackage ./gitbutler.nix {};
      nvim = callPackage ./nvim {};
      scripts = callPackage ./mybash {};
      enpass = callPackage ./enpass {};
      sonarr = callPackage ./sonarr {};
      radarr = callPackage ./radarr {};
      plex = callPackage ./plex {};
      jackett = callPackage ./jackett {};
      bazarr = callPackage ./bazarr {};
      gil = callPackage ./gil {};
      #arm-sonarr = pkgs.pkgsCross.${arm}.callPackage ./sonarr {};
      arm-sonarr = armpkgs.callPackage ./sonarr {};
      flaresolverr = python3Packages.callPackage ./flaresolverr.nix {};
      magic-wormhole-transit = python3Packages.callPackage ./magic-wormhole-transit.nix {};
      prowlarr = callPackage ./prowlarr {};
      ombi = callPackage ./ombi {};
      tautulli = python3Packages.callPackage ./tautulli {};
      seafile = callPackage ./seafile {};
      kpcli = callPackage ./kpcli.nix {};
      octodns = python3Packages.callPackage ./octodns.nix {};
      octodns-ovh = python3Packages.callPackage ./octodns-ovh.nix {};
      kubeshark = callPackage ./kubeshark {} ;
      docker-base-latest = callPackage ./docker {} ;
      docker-base-debug = callPackage ./docker/debug.nix {} ;
      aiac = callPackage ./aiac {} ;
      gitops = callPackage ./gitops.nix {} ;
      docker-sonarr = callPackage ./sonarr/docker.nix { inherit docker-base-latest docker-base-debug ; } ;
      docker-prowlarr = callPackage ./prowlarr/docker.nix {} ;
      docker-jackett = callPackage ./jackett/docker.nix {} ;
      docker-radarr = callPackage ./radarr/docker.nix {} ;
      docker-tautulli = callPackage ./tautulli/docker.nix {} ;
      docker-ombi = callPackage ./ombi/docker.nix {} ;
    };
  };
}
