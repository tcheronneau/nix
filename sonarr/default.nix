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
    x64-linux_hash = "sha256-/vsU0M8jyyfYVpE75gSa7R6aSyhxBg8gO3c+G3qCA+E=";
    arm64-linux_hash = "sha256-UA+w8jL2nhQPugEPXYp4yg5xXt4VFyCYMAWm55M7ND8=";
    x64-osx_hash = "sha256-OJX9/SyqFSEUWzbOdXth/3UohK5dmMqIkoqrmP/4o+0=";
    arm64-osx_hash = "sha256-oJq3+uDICXLv8fMtumSEdXn95bXSsrozUxAptealmH0=";
  }."${arch}-${os}_hash";
in
stdenv.mkDerivation rec {
  pname = "sonarr";
  version = "4.0.12.2823";

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
