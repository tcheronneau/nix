{ 
  callPackage
, lib
, dockerTools
, debug ? false 
, docker-base-debug
, docker-base-latest
, cacert
, runtimeShell
}:

let 
  sonarr = callPackage ./default.nix {};
  base = if debug then
    docker-base-debug
  else
    docker-base-latest;
  tag = if debug then
    "nix-debug"
  else
    "nix";
in 
  dockerTools.buildLayeredImage {
    name = "mcth/sonarr";
    fromImage = base;
    contents = [ cacert ];
    tag = tag;
    created = "now";
    config = {
      Cmd = [
        "${sonarr}/bin/NzbDrone"
        "-nobrowser" "-data=/config"
      ];
      Env = ["COMPlus_EnableDiagnostics=0"];
      ExposedPorts = {
        "8989/tcp" = { };
      };
    };
  }
