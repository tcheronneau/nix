{ pkgs }:
let ombi = pkgs.callPackage ./default.nix {};
in 
  pkgs.dockerTools.buildLayeredImage {
    name = "mcth/ombi";
    contents = [ ombi ];
    tag = "nix";
    created = "now";
    config = {
      Cmd = [
        "${ombi}/bin/Ombi"
         "--storage" "/config" "--host" "http://*:3579"
      ];
      Env = ["COMPlus_EnableDiagnostics=0"];
      ExposedPorts = {
        "3579/tcp" = { };
      };
    };
  }
