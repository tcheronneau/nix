{ lib, stdenv, fetchurl, mono, libmediainfo, sqlite, curl, makeWrapper, icu, dotnet-runtime, openssl, nixosTests, zlib }:

let
  os =
    if stdenv.isDarwin then
      "osx"
    else if stdenv.isLinux then
      "linux"
    else
      throw "Not supported on ${stdenv.hostPlatform.system}.";

  arch = {
    x86_64-linux = "x64";
    aarch64-linux = "arm64";
    x86_64-darwin = "x64";
  }."${stdenv.hostPlatform.system}" or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  hash = {
    x64-linux_hash = "sha256-bHdI+eVBQAPQAceP2zDnxj9uh/z5aA84W1leFO5Fw0w=";
    arm64-linux_hash = "sha256-4bqK+fEkYk9LK3suWgqoSzf9vKtPpbYGuEL62M/KHR4=";
    x64-osx_hash = "sha256-azG6bG7zwzZ/VU5TfjS7w3OecRb4ovgAbjlAcIyGBCM=";
  }."${arch}-${os}_hash";

in stdenv.mkDerivation rec {
  pname = "prowlarr";
  version = "1.32.2.4987";

  src = fetchurl {
    url = "https://github.com/Prowlarr/Prowlarr/releases/download/v${version}/Prowlarr.master.${version}.${os}-core-${arch}.tar.gz";
    sha256 = hash;
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/${pname}-${version}}
    cp -r * $out/share/${pname}-${version}/.

    makeWrapper "${dotnet-runtime}/bin/dotnet" $out/bin/Prowlarr \
      --add-flags "$out/share/${pname}-${version}/Prowlarr.dll" \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [
        curl sqlite libmediainfo mono openssl icu zlib ]}

    runHook postInstall
  '';

  passthru = {
    updateScript = ./update.sh;
    tests.smoke-test = nixosTests.prowlarr;
  };

  meta = with lib; {
    description = "An indexer manager/proxy built on the popular arr .net/reactjs base stack";
    homepage = "https://wiki.servarr.com/prowlarr";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ jdreaver ];
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" ];
  };
}
