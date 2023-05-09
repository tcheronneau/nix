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
<<<<<<< HEAD
    x64-linux_hash = "sha256-GbEQuTKCVfLd0oZbPKbVVbgGMi+eooBpc9zL2k/L3zY=";
    arm64-linux_hash = "sha256-s2TP8t+87ZQka9q0AQBfxpBwryx/qNqXfxYojvJEaAU=";
    x64-osx_hash = "sha256-nhWyAlc7vuM2c66lJ2e2sXFZlw7vWL9cKiDNrUS6LEs=";
=======
    x64-linux_hash = "sha256-LE1tfZIULPooIuk4thFpkH+Arw9jpaAk2Wf7EthsMQs=";
    arm64-linux_hash = "sha256-FsCzP5L0XT+ZJTlxIrjV9X3z7IbV8TH9hBFc2AnEAtc=";
    x64-osx_hash = "sha256-XgtQ+4r/5jsXxULHe0e3T1vWTNIPEOMhk0xBscJjywQ=";
>>>>>>> 2ec4412f122400d411c3fc78ddc8b9688ee80803
  }."${arch}-${os}_hash";

in stdenv.mkDerivation rec {
  pname = "prowlarr";
<<<<<<< HEAD
  version = "1.4.1.3258";
=======
  version = "1.4.0.3230";
>>>>>>> 2ec4412f122400d411c3fc78ddc8b9688ee80803

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
