{ lib, stdenv, fetchurl, mono, libmediainfo, sqlite, curl, makeWrapper, icu, dotnet-runtime, openssl, nixosTests, zlib }:

let
  os = if stdenv.isDarwin then "osx" else "linux";
  arch = {
    x86_64-linux = "x64";
    aarch64-linux = "arm64";
    x86_64-darwin = "x64";
  }."${stdenv.hostPlatform.system}" or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  hash = {
    x64-linux_hash = "sha256-Cc4OVLPHBQYz1LgLvl8LcVdOikJWRns5B/XlonXzY9w=";
    arm64-linux_hash = "sha256-7fq7u/IjUIDkcZJ1jSX21aWgecD+IIGyQozQ3Vl/X/8=";
    x64-osx_hash = "sha256-NoAx81usbi/RJYX4c++GMp+Xfl5GsdYe64H77GW/PuY=";
  }."${arch}-${os}_hash";

in stdenv.mkDerivation rec {
  pname = "radarr";
  version = "5.1.0.8172";

  src = fetchurl {
    url = "https://github.com/Radarr/Radarr/releases/download/v${version}/Radarr.develop.${version}.${os}-core-${arch}.tar.gz";
    sha256 = hash;
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/${pname}-${version}}
    cp -r * $out/share/${pname}-${version}/.

    makeWrapper "${dotnet-runtime}/bin/dotnet" $out/bin/Radarr \
      --add-flags "$out/share/${pname}-${version}/Radarr.dll" \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [
        curl sqlite libmediainfo mono openssl icu zlib ]}

    runHook postInstall
  '';

  passthru = {
    updateScript = ./update.sh;
    tests.smoke-test = nixosTests.radarr;
  };

  meta = with lib; {
    description = "A Usenet/BitTorrent movie downloader";
    homepage = "https://radarr.video/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ edwtjo purcell ];
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" ];
  };
}
