{ buildGoModule, fetchFromGitHub, lib, python311Packages, makeWrapper}:
let 
  bins = [python311Packages.gunicorn];
in
buildGoModule rec {
  pname = "authentik";
  version = "2024.4.0";
  src = fetchFromGitHub {
    owner = "goauthentik";
    repo = "authentik";
    rev = "version/${version}";
    hash = "sha256-+nCqLd3BE6lRPj9sgbmXkpY+H0yT5OgEZ7LVSxhMCg8=";
  };

  subPackages = [ "cmd/server" ];
  buildInputs = []++bins;
  nativeBuildInputs = [makeWrapper]++bins;
  vendorHash = "sha256-YpOG5pNw5CNSubm1OkPVpSi7l+l5UdJFido2SQLtK3g=";
  checkPhase = "";
  postInstall = ''
    wrapProgram $out/bin/server \
      --set PATH ${lib.makeBinPath bins}
  '';


  meta = with lib; {
    homepage = "https://goauthentik.io/";
    description = "The authentication glue you need.";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.bsd2;
    maintainers = with maintainers; [ tcheronneau ];
  };
}
