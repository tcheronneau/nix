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
  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${src}/warpgate-web/yarn.lock";
    hash = "sha256-tYJvyYDzXQTQigr/uPIgDGHaTBk1EYiu8kNI5EN75DI=";
  };
  src = fetchFromGitHub {
    owner = "warp-tech";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-WqYE18MHE+A3D4SsAj0Y2ZDmuXHm5s2MuBoRXfIrDPI=";
  };
  #warpgate-api-client = stdenv.mkDerivation {
  #  name = "api-client";
  #  src = "${src}";
  #  nativeBuildInputs = [
  #    cargo
  #    openapi-generator-cli
  #    nodejs
  #    yarn
  #  ];
  #  buildPhase = ''
  #    cargo run -p warpgate-protocol-http > openapi-schema.json
  #    openapi-generator-cli generate -g typescript-fetch -i openapi-schema.json -o api-client -p npmName=warpgate-gateway-api-client -p useSingleRequestParameter=true
  #    cd api-client
  #    npm i typescript@5 
  #    npm i  
  #    yarn tsc --target esnext --module esnext
  #  '';
  #  installPhase = ''
  #    mkdir -p $out/api-client
  #    cp -r api-client/* $out/api-client
  #  '';
  #};
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
  inherit pname version src;

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

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  postInstall = ''
    mkdir -p $out/share/warpgate/config
    cp ../config/warpgate.yaml $out/share/warpgate/config/warpgate.yaml
    wrapProgram $out/bin/warpgate --set-default QW_CONFIG $out/share/warpgate/config/warpgate.yaml
  '';


  meta = with lib; {
    description = "Smart SSH, HTTPS and MySQL bastion that requires no additional client-side software";
    homepage = "https://github.com/warp-tech/warpgate";
    license = licenses.asl20;
    maintainers = with maintainers; [ tcheronneau ];
    platforms = platforms.all;
  };
}
