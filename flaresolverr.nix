{ lib, fetchFromGitHub, buildPythonPackage, python310, wrapPython, makeWrapper, chromedriver, chromium }:
let 
  pydep = with python310.pkgs; [
    bottle
    waitress
    selenium
    func-timeout
    requests
    websockets
    xvfbwrapper
  ];
in 
buildPythonPackage rec {
  pname = "FlareSolverr";
  version = "3.0.2";
  format = "other";

  pythonPath = [ python310 ];
  nativeBuildInputs = [ wrapPython makeWrapper ];
  propagatedBuildInputs = [ python310 pydep chromium chromedriver ];

  src = fetchFromGitHub {
    owner = "FlareSolverr";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-zpeJf1CaQ4bsncZz44sH+tFKddYrZf7YdNYL50d9GA4=";
  };
  dontUseSetuptoolsCheck = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/src
    cp -r . $out/src
    chmod +x $out/src/src/flaresolverr.py
    makeWrapper $out/src/src/flaresolverr.py $out/bin/flaresolverr \
      --prefix PYTHONPATH : "$PYTHONPATH"
    runHook postInstall
  '';

  meta  = with lib; {
    description = "Proxy server to bypass Cloudflare protection";
    homepage = "https://github.com/FlareSolverr/FlareSolverr";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ csingley ];
  };
}

