with import <nixpkgs> {} ;
let 
  testing = pkgs.writeShellScriptBin "dgoss" ''
    ${pkgs.dgoss}/bin/dgoss run --pull=always registry.mcth.fr/docker/sonarr:latest
  '';
in 
stdenv.mkDerivation rec {
  name = "test-environment";
  buildInputs = [ testing ];
}
