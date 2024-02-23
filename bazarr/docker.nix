{ pkgs }:
let bazarr = pkgs.python3Packages.callPackage ./default.nix {};
in 
  pkgs.dockerTools.buildLayeredImage {
    name = "mcth/bazarr";
    contents = [ bazarr ];
    tag = "nix";
    created = "now";
    config = {
      Cmd = [
        "${bazarr}/bin/bazarr"
        "--no-update"
        "--config=/config"
      ];
      ExposedPorts = {
        "6767/tcp" = { };
      };
    };
  }
