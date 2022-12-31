{ callPackage, dockerTools, cacert }:
let jackett = callPackage ./default.nix {};
in 
  dockerTools.buildLayeredImage {
    name = "mcth/jackett";
    contents = [ jackett dockerTools.caCertificates ];
    tag = "nix";
    created = "now";
    extraCommands = "mkdir -m 0777 tmp";
    config = {
      Cmd = [
        "${jackett}/bin/jackett"
        "--NoUpdates"
      ];
      Env = [
        "COMPlus_EnableDiagnostics=0"
        "XDG_DATA_HOME=/config"
        "XDG_CONFIG_HOME=/config"
      ];
      ExposedPorts = {
        "9117/tcp" = { };
      };
    };
  }
