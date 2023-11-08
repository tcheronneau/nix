{ pkgs }:

let 
  radarr = pkgs.callPackage ./default.nix {};
  base = pkgs.dockerTools.buildImage {
    name = "mcth/base";
    tag = "latest";
    created = "now";
    runAsRoot = ''
      #!${pkgs.runtimeShell}
      ${pkgs.dockerTools.shadowSetup}
      groupadd -g 1005 -r radarr
      useradd -u 1005 -r -g radarr radarr
      mkdir -p /config
      chown -R radarr:radarr /config
    '';
  };
in 
  pkgs.dockerTools.buildLayeredImage {
    name = "mcth/radarr";
    fromImage = base;
    contents = [ pkgs.cacert ];
    tag = "nix";
    created = "now";
    config = {
      Cmd = [
        "${radarr}/bin/Radarr"
        "-nobrowser" "-data=/config"
      ];
      Env = ["COMPlus_EnableDiagnostics=0"];
      User = "radarr";
      ExposedPorts = {
        "7878/tcp" = { };
      };
    };
  }
