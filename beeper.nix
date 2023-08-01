{ fetchurl, appimageTools, makeDesktopItem, ... }:
let 
  pname = "beeper";
  version = "";
  desktopItem = makeDesktopItem {
    name = pname;
    desktopName = pname;
    comment = "Beeper is an aggregator of messaging apps";
    exec = pname;
    icon = "beeper";
  };
  src = fetchurl {
    url = "https://download.beeper.com/linux/appImage/x64";
    hash = "sha256-48VRjhGVIKdmMsepbmTih8Lb4vJeCIAp6E1CfD06Tx8="; 
  };
  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };
in 
  appimageTools.wrapType2 rec { # or wrapType1
    inherit pname version src;

    extraInstallCommands = ''
      mkdir -p $out/share
      cp -r ${desktopItem}/share/applications $out/share
      cp -r ${appimageContents}/usr/share/icons $out/share/icons
      mv $out/bin/${pname}-${version} $out/bin/${pname}
    '';
  }
