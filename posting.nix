{
  lib,
  fetchFromGitHub,
  python3Packages,
  xorg,
}:
let
  textual-autocomplete = python3Packages.callPackage ./python-textual.nix {};
in
python3Packages.buildPythonApplication rec {
  pname = "posting";
  version = "2.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "darrenburns";
    repo = "posting";
    tag = version;
    sha256 = "sha256-lL85gJxFw8/e8Js+UCE9VxBMcmWRUkHh8Cq5wTC93KA=";
  };

  pythonRelaxDeps = true;

  nativeBuildInputs = [ python3Packages.hatchling ];

  # Required for x resources themes
  buildInputs = [ xorg.xrdb ];

  dependencies =
    with python3Packages;
    [
      click
      xdg-base-dirs
      click-default-group
      pyperclip
      pyyaml
      python-dotenv
      watchfiles
      pydantic
      pydantic-settings
      httpx
      textual-autocomplete
      textual
    ]
    ++ httpx.optional-dependencies.brotli
    ++ textual.optional-dependencies.syntax;

  meta = {
    description = "Modern API client that lives in your terminal";
    mainProgram = "posting";
    homepage = "https://posting.sh/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jorikvanveen ];
    platforms = lib.platforms.unix;
  };
}
