{ pkgs }:
let jackett = pkgs.callPackage ./default.nix {};
in 
  pkgs.dockerTools.buildLayeredImage {
    name = "registry.mcth.fr/docker/jackett";
    contents = [ jackett ];
    tag = "nix";
    created = "now";
    extraCommands = "mkdir -m 0777 tmp";
    config = {
      Cmd = [
        "${pkgs.jackett}/bin/jackett"
        "--NoUpdates"
      ];
      Env = ["COMPlus_EnableDiagnostics=0"];
      ExposedPorts = {
        "9117/tcp" = { };
      };
    };
  }
