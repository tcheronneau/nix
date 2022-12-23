{ pkgs }:
let tautulli = pkgs.callPackage ./default.nix {};
in 
  pkgs.dockerTools.buildLayeredImage {
    name = "mcth/tautulli";
    contents = [ tautulli ];
    tag = "nix";
    created = "now";
    config = {
      Cmd = [
        "${tautulli}/bin/tautulli"
        "--datadir=/config"
      ];
      ExposedPorts = {
        "8181/tcp" = { };
      };
    };
  }
