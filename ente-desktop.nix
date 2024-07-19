{ fetchurl, appimageTools, makeDesktopItem, makeWrapper, ... }:
let 
  pname = "ente-desktop";
  version = "latest";
  desktopItem = makeDesktopItem {
    name = pname;
    desktopName = pname;
    comment = "Ente Desktop";
    exec = pname;
    icon = "ente-desktop";
  };
  src = fetchurl {
    url = "https://objects.githubusercontent.com/github-production-release-asset-2e65be/353965811/bef9163a-3220-4f92-9a52-4eed0bdf59f7?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=releaseassetproduction%2F20240521%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20240521T063838Z&X-Amz-Expires=300&X-Amz-Signature=decf1eefe56c8dcee7460d56b5fa71618495f50f60bc8ff2505281854fca069a&X-Amz-SignedHeaders=host&actor_id=7914437&key_id=0&repo_id=353965811&response-content-disposition=attachment%3B%20filename%3Dente-1.6.63-x86_64.AppImage&response-content-type=application%2Foctet-stream";
    hash = "sha256-K2rNLHtzyh9/y54dz0l58XYnzsjP+qGl6OH9CExR2jU=";
  };
  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };
in 
  appimageTools.wrapType2 rec { # or wrapType1
    inherit pname version src;

    extraInstallCommands = ''
      runHook preInstall
      mkdir -p $out/share
      cp -r ${desktopItem}/share/applications $out/share
      cp -r ${appimageContents}/usr/share/icons $out/share/icons
      mv $out/bin/${pname}-${version} $out/bin/${pname}
    '';
    extraPkgs = pkgs: with pkgs; [ libsecret ];
  }
