{ fetchurl, appimageTools, makeDesktopItem, makeWrapper, ... }:
let 
  pname = "gitbutler";
  version = "";
  desktopItem = makeDesktopItem {
    name = pname;
    desktopName = pname;
    comment = "Source Code Management, Refined.gitbutler is an aggregator of messaging apps";
    exec = pname;
    icon = "gitbutler";
  };
  src = fetchurl {
    url = "https://releases.gitbutler.com/releases/release/0.9.10-484/linux/x86_64/git-butler_0.9.10_amd64.AppImage";
    hash = "sha256-8M7L1rj109wBXDcULzn4lbHFtLUEwdKmRTHJq9IUlK0=";
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
    extraPkgs = pkgs: with pkgs; [ libthai ];
  }
