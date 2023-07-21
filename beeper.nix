{ fetchurl, appimageTools, makeDesktopItem, ... }:
let 
  name = "beeper";
  desktopItem = makeDesktopItem {
    name = name;
    desktopName = name;
    comment = "Beeper is an aggregator of messaging apps";
    exec = name;
    icon = "beeper";
  };
in 
  appimageTools.wrapType2 { # or wrapType1
    name = "beeper";
    src = fetchurl {
      url = "https://download.beeper.com/linux/appImage/x64";
      hash = "sha256-OPtp0lXo4Xw0LQOR9CuOaDdd2+YhaBMjvgWlvbPU2cM=";
    };
    extraInstallCommands = ''
      mkdir -p $out/share
      cp -r ${desktopItem}/share/applications $out/share
    '';
  }
