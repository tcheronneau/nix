{ pkgs }:
let prowlarr = pkgs.callPackage ./default.nix {};
in 
  pkgs.dockerTools.buildLayeredImage {
    name = "mcth/prowlarr";
    contents = [ prowlarr ];
    tag = "nix";
    created = "now";
    config = {
      Cmd = [
        "${prowlarr}/bin/Prowlarr"
        "-nobrowser" "-data=/config"
      ];
      ExposedPorts = {
        "9696/tcp" = { };
      };
    };
  }
