{ stdenv
, lib
, fetchFromGitHub
, makeWrapper
, rustPlatform
, rust-jemalloc-sys
, nodejs
, yarn
, fetchYarnDeps
, yarn2nix-moretea
, jre
, cargo
}:

let
  pname = "warpgate-protocol-http";
  version = "0.10.2";
  hash = "sha256-WqYE18MHE+A3D4SsAj0Y2ZDmuXHm5s2MuBoRXfIrDPI=";
  src = fetchFromGitHub {
    owner = "warp-tech";
    repo = pname;
    rev = "v${version}";
    hash = hash; 
  };
  sourceRoot = "${src.name}/warpgate-protocol-http";
in
rustPlatform.buildRustPackage rec {
  inherit pname version src;

  cargoSha256 = "sha256-oWn1kfxAm829r5tnFx3Cx6pcMUAecmsEKAVU9hhQ4c8=";
  #cargoDeps = rustPlatform.fetchCargoTarball {
  #  inherit src sourceRoot;
  #  name = "${pname}-${version}";
  #  hash = "";
  #};




  meta = with lib; {
    description = "Smart SSH, HTTPS and MySQL bastion that requires no additional client-side software";
    homepage = "https://github.com/warp-tech/warpgate";
    license = licenses.asl20;
    maintainers = with maintainers; [ tcheronneau ];
    platforms = platforms.all;
  };
}
