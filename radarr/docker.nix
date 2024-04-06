{ pkgs
, debug ? false 
, docker-base-debug
, docker-base-latest
}:

let 
  radarr = pkgs.callPackage ./default.nix {};
  base = if debug then
    docker-base-debug
  else
    docker-base-latest;
  tag = if debug then
    "nix-debug"
  else
    "nix";
in 
  pkgs.dockerTools.buildLayeredImage {
    name = "mcth/radarr";
    fromImage = base;
    contents = [ pkgs.cacert ];
    tag = tag;
    created = "now";
    config = {
      Cmd = [
        "${radarr}/bin/Radarr"
        "-nobrowser" "-data=/config"
      ];
      Env = ["COMPlus_EnableDiagnostics=0"];
      ExposedPorts = {
        "7878/tcp" = { };
      };
    };
  }
