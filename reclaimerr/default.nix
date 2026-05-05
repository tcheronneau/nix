{ lib, stdenv, fetchurl, makeWrapper, autoPatchelfHook, unzip, zlib, stdenv_32bit ? null }:

let
  os = if stdenv.isDarwin then "macos" else "linux";
  arch = {
    x86_64-linux = "x64";
    x86_64-darwin = "x64";
  }."${stdenv.hostPlatform.system}" or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  hash = {
    x64-linux_hash = "sha256-IzKgr0vspARwk1C9Nx1Z6NUS43ZK3wMnzqUnnbOo5UQ=";
    x64-macos_hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  }."${arch}-${os}_hash";

in stdenv.mkDerivation rec {
  pname = "reclaimerr";
  version = "0.1.0-beta.13";

  sourceRoot = ".";

  src = fetchurl {
    url = "https://github.com/jessielw/Reclaimerr/releases/download/${version}/reclaimerr-${os}-${arch}.zip";
    sha256 = hash;
  };

  nativeBuildInputs = [ unzip makeWrapper ]
    ++ lib.optional stdenv.hostPlatform.isLinux autoPatchelfHook;

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ zlib stdenv.cc.cc.lib ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/${pname}
    cp -r dist/reclaimerr/. $out/share/${pname}/

    mkdir -p $out/bin
    makeWrapper $out/share/${pname}/reclaimerr $out/bin/reclaimerr \
      --chdir "$out/share/${pname}"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Automatically reclaim space in your media library using customizable rules";
    homepage = "https://github.com/jessielw/Reclaimerr";
    license = licenses.gpl3Only;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ tcheronneau ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    mainProgram = "reclaimerr";
  };
}
