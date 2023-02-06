{ dockerTools, bash, coreutils, busybox, curl, callPackage }:
let
  base = callPackage ./default.nix {};
in
dockerTools.buildLayeredImage {
  fromImage = base;
  name = "mcth/base";
  tag = "debug";
  created = "now";
  contents = [ bash coreutils busybox curl ];
}
