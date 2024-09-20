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
  pname = "warpgate";
  version = "0.10.2";
  hash = "sha256-WqYE18MHE+A3D4SsAj0Y2ZDmuXHm5s2MuBoRXfIrDPI=";
  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${src}/warpgate-web/yarn.lock";
    hash = "sha256-tYJvyYDzXQTQigr/uPIgDGHaTBk1EYiu8kNI5EN75DI=";
  };
  src = fetchFromGitHub {
    owner = "warp-tech";
    repo = pname;
    rev = "v${version}";
    hash = hash; 
  };
  warpgate-protocol-http = rustPlatform.buildRustPackage {
    inherit pname version src;
    cargoLock = {
      lockFile = ./Cargo.lock;
    };
  };
  warpgate-ui = stdenv.mkDerivation {
    name = "warpgate-web";
    src = "${src}";
    nativeBuildInputs = [
      nodejs
      yarn
      yarn2nix-moretea.fixup_yarn_lock
      jre
      cargo
    ];
    configurePhase = ''
      export HOME=$(mktemp -d)
    '';
    buildPhase = ''
      yarn --cwd warpgate-web config --offline set yarn-offline-mirror ${yarnOfflineCache}
      fixup_yarn_lock ./warpgate-web/yarn.lock

      yarn --cwd warpgate-web install --offline \
        --frozen-lockfile \
        --ignore-engines --ignore-scripts
      patchShebangs .
      yarn --cwd warpgate-web openapi:schema:gateway
      ${warpgate-protocol-http}/bin/warpgate-protocol-http > src/gateway/lib/openapi-schema.json
      yarn openapi:client:gateway

      yarn build
    '';
    installPhase =  ''
      mkdir $out
      mv build/* $out
    '';
  };
in
rustPlatform.buildRustPackage rec {
  inherit pname version src ;
  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  sourceRoot = "${src.name}/warpgate";

  preBuild = ''
    mkdir -p warpgate-web/build 
    cp -r ${warpgate-ui}/* warpgate-web/build
  '';

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    rust-jemalloc-sys
  ];


  meta = with lib; {
    description = "Smart SSH, HTTPS and MySQL bastion that requires no additional client-side software";
    homepage = "https://github.com/warp-tech/warpgate";
    license = licenses.asl20;
    maintainers = with maintainers; [ tcheronneau ];
    platforms = platforms.all;
  };
}
