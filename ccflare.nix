{ pkgs, stdenv, fetchFromGitHub, bun, makeWrapper }:

let
  src = fetchFromGitHub {
    owner = "snipeship";
    repo = "ccflare";
    rev = "688921203f5035e09740ad4f8208d222122d9ea9";
    hash = "sha256-JDrk+BDGMI535JGTwZdf+iYAwHouLi9Yq+cRIxc/3Yk=";
  };

  bunDeps = stdenv.mkDerivation {
    pname = "ccflare-deps";
    version = "0.1.0";
    inherit src;
    nativeBuildInputs = [ bun ];
    dontFixup = true;
    buildPhase = ''
      export HOME=$TMPDIR
      bun install --frozen-lockfile
    '';
    installPhase = ''
      cp -r node_modules $out
    '';
    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash = "sha256-g3/R6BgZFMAylIR+9yPFlIW6oWHftVLp0D/6iT+tb0w=";
  };
in
stdenv.mkDerivation {
  pname = "ccflare";
  version = "0.1.0";
  inherit src;

  nativeBuildInputs = [ bun makeWrapper ];

  buildPhase = ''
    runHook preBuild

    cp -r ${bunDeps} node_modules
    chmod -R u+w node_modules
    export HOME=$TMPDIR
    bun run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/ccflare
    cp -r . $out/lib/ccflare

    mkdir -p $out/bin
    makeWrapper ${bun}/bin/bun $out/bin/ccflare \
      --prefix PATH : ${bun}/bin \
      --chdir $out/lib/ccflare \
      --add-flags "run" \
      --add-flags "tui"

    runHook postInstall
  '';

  meta = with pkgs.lib; {
    description = "Claude API proxy with intelligent load balancing across multiple accounts";
    homepage = "https://github.com/snipeship/ccflare";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
