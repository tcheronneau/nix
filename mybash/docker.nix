{ pkgs ? import <nixpkgs> { }
, pkgsLinux ? import <nixpkgs> { system = "x86_64-linux"; }
, custom ? (import ./default.nix)
}:
with pkgs;

let
  baseDir = "${toString ./.}";

in dockerTools.buildImage {
  name = "mybash";
  tag = "latest";
  created = "now";
  config= {
    Entrypoint = ["${custom}/bin/urlencode"];
  };
  contents = [
    custom
  ];
}
