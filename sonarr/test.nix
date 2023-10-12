with import <nixpkgs> {} ;
let 
  testing = pkgs.writeShellScriptBin "dgoss" ''
    ${pkgs.dgoss}/bin/dgoss run registry.mcth.fr/docker/sonarr:latest
  '';
in 
#stdenv.mkDerivation rec {
  #name = "test-environment";
  #buildInputs = [ testing ];
pkgs.mkShell rec { 
  buildInputs = [ testing ];
  shellHook = "dgoss";
}
