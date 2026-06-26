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
    x64-linux_hash = "sha256-tpGzWEwxwLVRQFje6BBxySP2PVmjfRnjL5L6E+qhU9s=";
    arm64-linux_hash = "sha256-jZe+SlVLEik8JtvCpGBvQk1yJrUiqXUEiCTs+UGiGqU=";
    x64-osx_hash = "sha256-L/grGytac4o/qQal7fCUmZhij1NIAbsRahNM1G7a/rQ=";
    arm64-osx_hash = "sha256-F4+aOF2RBFoOVQAcYhKAuSk37pVBW6EwBBjJ4+Z3L0E=";
  }."${arch}-${os}_hash";
in
stdenv.mkDerivation rec {
  pname = "sonarr";
  version = "4.0.19.2979";

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
