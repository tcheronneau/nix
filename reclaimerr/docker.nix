{ pkgs
, debug ? false
, docker-base-debug
, docker-base-latest
}:

let
  reclaimerr = pkgs.callPackage ./default.nix {};
  base = if debug then docker-base-debug else docker-base-latest;
  tag = if debug then "nix-debug" else "nix";
in
  pkgs.dockerTools.buildLayeredImage {
    name = "mcth/reclaimerr";
    fromImage = base;
    contents = [ pkgs.cacert ];
    tag = tag;
    created = "now";
    config = {
      Cmd = [ "${reclaimerr}/bin/reclaimerr" ];
      Env = [ "RECLAIMERR_DATA=/config" ];
      ExposedPorts = {
        "8000/tcp" = { };
      };
      Volumes = {
        "/config" = { };
      };
    };
  }
