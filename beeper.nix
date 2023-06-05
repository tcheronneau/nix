{ fetchurl, appimageTools, ... }:
appimageTools.wrapType2 { # or wrapType1
  name = "beeper";
  src = fetchurl {
    url = "https://download.beeper.com/linux/appImage/x64";
    hash = "sha256-+g59ZQcZIWV3oE07QBINqaCIyQETabkBrlp4PZ9TrjU=";
  };
}
