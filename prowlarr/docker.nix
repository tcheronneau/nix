{ pkgs }:
let
  prowlarr = pkgs.callPackage ./default.nix {};
  base = pkgs.dockerTools.buildImage {
    name = "mcth/base";
    tag = "latest";
    created = "now";
    runAsRoot = ''
      #!${pkgs.runtimeShell}
      ${pkgs.dockerTools.shadowSetup}
      groupadd -g 1005 -r prowlarr
      useradd -u 1005 -r -g prowlarr prowlarr
      mkdir -p /config
      mkdir -p /config/Definitions/Custom
      cp ${./yggtorrent.yml} /config/Definitions/Custom/yggtorrent.yml

      chown -R prowlarr:prowlarr /config
    '';
  };
in
  pkgs.dockerTools.buildLayeredImage {
    name = "mcth/prowlarr";
    fromImage = base;
    contents = [ prowlarr pkgs.cacert ];
    tag = "nix";
    created = "now";
    config = {
      Cmd = [
        "${prowlarr}/bin/Prowlarr"
        "-nobrowser" "-data=/config"
      ];
      Env = ["COMPlus_EnableDiagnostics=0"];
      User = "prowlarr";
      ExposedPorts = {
        "9696/tcp" = { };
      };
    };
  }
