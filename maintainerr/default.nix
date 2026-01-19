{
  fetchFromGitHub,
  lib,
  makeWrapper,
  nodejs,
  python3,
  stdenv,
  yarn-berry_4,
}:

let
  yarn-berry = yarn-berry_4;
in
stdenv.mkDerivation rec {
  pname = "maintainerr";
  version = "2.26.0";

  src = fetchFromGitHub {
    owner = "Maintainerr";
    repo = "Maintainerr";
    tag = "v${version}";
    hash = "sha256-PHu+GQiGuHFESfD3Nuuikum6AqmPeqBUNgEI8ITERhQ=";
  };

  missingHashes = ./missing-hashes.json;

  offlineCache = yarn-berry.fetchYarnBerryDeps {
    inherit src missingHashes;
    hash = "sha256-1Qiy3Duy+jKnALc86LAIP0abpey3wV04SU3hSn0Ny98=";
  };

  nativeBuildInputs = [
    makeWrapper
    nodejs
    python3
    yarn-berry
    yarn-berry.yarnBerryConfigHook
  ];

  buildPhase = ''
    runHook preBuild
    yarn build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/maintainerr
    cp -r apps $out/lib/maintainerr/
    cp -r packages $out/lib/maintainerr/
    cp -r node_modules $out/lib/maintainerr/

    mkdir -p $out/bin
    makeWrapper "${lib.getExe nodejs}" "$out/bin/maintainerr" \
      --set NODE_ENV production \
      --chdir "$out/lib/maintainerr/apps/server" \
      --add-flags "dist/main.js"

    runHook postInstall
  '';

  meta = {
    badPlatforms = [
      # FileNotFoundError: [Errno 2] No such file or directory: 'xcodebuild'
      lib.systems.inspect.patterns.isDarwin
    ];
    changelog = "https://github.com/Maintainerr/Maintainerr/releases/tag/v${version}";
    description = "Maintenance tool for the Plex ecosystem ";
    homepage = "https://github.com/Maintainerr/Maintainerr";
    license = lib.licenses.mit;
    mainProgram = "maintainerr";
    maintainers = with lib.maintainers; [ tcheronneau ];
  };
}
