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
    x64-linux_hash = "sha256-H8SFRLWjQBsvw9+NBkLB5qc6KOQaNRFp7dnNj1R3DbU=";
    arm64-linux_hash = "sha256-vZP38GuMuUDaCBQQbRKT3xK/kZmvBRTpW4k/DGA/x7k=";
    x64-osx_hash = "sha256-RYfRNGhNHqWFA6kVjtDIcxx3eAddNgDHWpAGS0Pjcyc=";
    arm64-osx_hash = "sha256-aBFsfk3CrKpXh40trj247t5CR5+geWrydrqwc4sxDuo=";
  }."${arch}-${os}_hash";
in
stdenv.mkDerivation rec {
  pname = "sonarr";
  version = "4.0.20.3014";

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
