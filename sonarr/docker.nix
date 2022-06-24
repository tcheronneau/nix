{ pkgs }:
pkgs.dockerTools.buildLayeredImage
  {
    name = "sonarr.nix";
    contents = [ pkgs.sonarr ];
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
