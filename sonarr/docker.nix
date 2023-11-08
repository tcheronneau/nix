{ 
  callPackage
, lib
, dockerTools
, docker-base-debug
, docker-base-latest
}:

let sonarr = callPackage ./default.nix {};
in 
  dockerTools.buildLayeredImage {
    name = "mcth/sonarr";
    #fromImage = docker-base-latest; 
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
