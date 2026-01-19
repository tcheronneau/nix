{
  fetchFromGitHub,
  fetchYarnDeps,
  lib,
  makeWrapper,
  node-gyp,
  node-pre-gyp,
  nodejs,
  python3,
  stdenv,
  yarnBuildHook,
  yarnConfigHook,
  yarnInstallHook,
}:

stdenv.mkDerivation rec {
  pname = "maintainerr";
  version = "2.26.0";

  src = fetchFromGitHub {
    owner = "Maintainerr";
    repo = "Maintainerr";
    tag = "v${version}";
    hash = lib.fakeHash;
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = lib.fakeHash;
  };

  env.CYPRESS_INSTALL_BINARY = 0;

  nativeBuildInputs = [
    makeWrapper
    node-gyp
    node-pre-gyp
    nodejs
    python3
    yarnBuildHook
    yarnConfigHook
    yarnInstallHook
  ];

  postInstall = ''
    # Fixes "Error: Cannot find module" (bcrypt) and "SQLite package has not been found installed".
    pushd $out/lib/node_modules/maintainerr/node_modules
    for module in bcrypt sqlite3; do
      pushd $module
      node-pre-gyp rebuild --build-from-source --nodedir=${nodejs} --prefer-offline
      popd
    done

    makeWrapper "${lib.getExe nodejs}" "$out/bin/maintainerr" \
      --set NODE_ENV production \
      --chdir "$out/lib/node_modules/maintainerr" \
      --add-flags "dist/index.js" \
      --add-flags "--"
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
