{ pkgs }:
let sonarr = pkgs.callPackage ./default.nix {};
in 
  pkgs.dockerTools.buildLayeredImage {
    name = "mcth/sonarr";
    contents = [ sonarr ];
    tag = "nix";
    created = "now";
    config = {
      Cmd = [
        "${sonarr}/bin/NzbDrone"
        "-nobrowser" "-data=/config"
      ];
      ExposedPorts = {
        "8989/tcp" = { };
      };
    };
  }
