with import <nixpkgs> {};

pkgs.stdenv.mkDerivation rec {
  pname = "mybash";
  version = "0.1.0";

  src = ./.;

  buildInputs = [
    pkgs.bash
  ];

  configurePhase = ''
    cat urlencode
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv switchvault $out/bin
    mv urlencode $out/bin
  '';
}
