{ pkgs }:
let radarr = pkgs.callPackage ./default.nix {};
in 
  pkgs.dockerTools.buildLayeredImage {
    name = "mcth/radarr";
    contents = [ radarr pkgs.cacert ];
    tag = "nix";
    created = "now";
    config = {
      Cmd = [
        "${pkgs.radarr}/bin/Radarr"
        "--no-browser" "-data=/config"
      ];
      Env = ["COMPlus_EnableDiagnostics=0"];
      ExposedPorts = {
        "7878/tcp" = { };
      };
    };
  }
