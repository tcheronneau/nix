{ lib, stdenv, fetchurl, mono, libmediainfo, sqlite, curl, makeWrapper, nixosTests }:

stdenv.mkDerivation rec {
  pname = "sonarr";
  version = "";

  src = fetchurl {
    url = "https://download.sonarr.tv/v3/main/${version}/Sonarr.main.${version}.linux.tar.gz";
    sha256 = "sha256-AzH1rZFqEH8sovZZfJykvsEmCedEZWigQFHWHl6/PdE=";
  };

  nativeBuildInputs = [ makeWrapper ];
  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r * $out/bin/
    makeWrapper "${mono}/bin/mono" $out/bin/NzbDrone \
      --add-flags "$out/bin/Sonarr.exe" \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [
          curl sqlite libmediainfo ]}

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
    platforms = lib.platforms.all;
  };
}
