{ 
  callPackage
, dockerTools
, cacert
, runtimeShell
, coreutils
, busybox
, bash
, curl
}:

let 
  sonarr = callPackage ./default.nix {};
  base = dockerTools.buildImage {
    name = "mcth/base";
    tag = "latest";
    created = "now";
    runAsRoot = ''
      #!${runtimeShell}
      ${dockerTools.shadowSetup}
      groupadd -g 1005 -r sonarr
      useradd -u 1005 -r -g sonarr sonarr 
      mkdir -p /config
      chown -R sonarr:sonarr /config
    '';
  };
in 
  dockerTools.buildLayeredImage {
    name = "mcth/sonarr";
    fromImage = base; 
    contents = [ cacert coreutils busybox bash curl ];
    tag = "nix-debug";
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
