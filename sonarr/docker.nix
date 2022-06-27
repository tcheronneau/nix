{ pkgs }:
let sonarr = pkgs.callPackage ./default.nix {};
in 
  pkgs.dockerTools.buildLayeredImage {
    name = "hub.mcth.fr/sonarr.nix";
    contents = [ sonarr ];
    tag = "latest";
    created = "now";
    config = {
      Cmd = [
        "${pkgs.sonarr}/bin/NzbDrone"
        "--no-browser" "-data=/config"
      ];
      ExposedPorts = {
        "8989/tcp" = { };
      };
    };
  }
