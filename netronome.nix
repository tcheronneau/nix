{
  stdenv,
  lib,
  fetchurl,
  autoPatchelfHook,
  gcc,
}:

let
  version = "0.8.0";
in
stdenv.mkDerivation {
  pname = "netronome";
  inherit version;

  src = fetchurl {
    url = "https://github.com/autobrr/netronome/releases/download/v${version}/netronome_${version}_linux_amd64.tar.gz";
    # Run once to get hash
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  nativeBuildInputs = [ autoPatchelfHook ];
  runtimeDependencies = [ gcc.cc.lib ];

  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/bin
    install -m755 netronome $out/bin/netronome
  '';

  meta = with lib; {
    description = "Modern network speed testing and monitoring tool";
    homepage = "https://github.com/autobrr/netronome";
    license = licenses.gpl2Only;
    mainProgram = "netronome";
    platforms = platforms.linux;
  };
}
