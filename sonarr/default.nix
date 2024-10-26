{ lib, stdenv, fetchurl, dotnet-runtime, icu, ffmpeg, openssl, sqlite, curl, makeWrapper, nixosTests }:

let
  os = if stdenv.isDarwin then "osx" else "linux";
  arch = {
    x86_64-linux = "x64";
    aarch64-linux = "arm64";
    x86_64-darwin = "x64";
    aarch64-darwin = "arm64";
  }."${stdenv.hostPlatform.system}" or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  hash = {
    x64-linux_hash = "sha256-jRrFl7f0vFT5zY6Kv8+Zdz4FZE6pvc2WMDtK722mKcg=";
    arm64-linux_hash = "sha256-crj5QLGhWgysGAa8vySMjwig9Mi/o1BHcdVDzC2OJXE=";
    x64-osx_hash = "sha256-cde6p22s0qNomhuYP12/Yr11wPrYDcXnFQ6T8hFKAkE=";
    arm64-osx_hash = "sha256-D2lIegUURjPG9T+rDKAooXn846K7zB221Y206mTETI0=";
  }."${arch}-${os}_hash";
in
stdenv.mkDerivation rec {
  pname = "sonarr";
  version = "4.0.10.2544";

  src = fetchurl {
    url = "https://github.com/Sonarr/Sonarr/releases/download/v${version}/Sonarr.main.${version}.${os}-${arch}.tar.gz";
    inherit hash;
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/sonarr-${version}}
    cp -r * $out/share/sonarr-${version}/.

    makeWrapper "${dotnet-runtime}/bin/dotnet" $out/bin/NzbDrone \
      --add-flags "$out/share/sonarr-${version}/Sonarr.dll" \
      --prefix PATH : ${lib.makeBinPath [ ffmpeg ]} \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ curl sqlite openssl icu ]}

    runHook postInstall
  '';

  passthru = {
    updateScript = ./update.sh;
    tests.smoke-test = nixosTests.sonarr;
  };

  meta = {
    description = "Smart PVR for newsgroup and bittorrent users";
    homepage = "https://sonarr.tv/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fadenb purcell ];
    mainProgram = "NzbDrone";
    platforms = lib.platforms.all;
  };
}
