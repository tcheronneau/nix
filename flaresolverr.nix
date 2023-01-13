{ lib, fetchFromGitHub, buildPythonPackage, python3, wrapPython, makeWrapper, chromedriver, chromium, xvfb-run }:
let 
  pydep = with python3.pkgs; [
    bottle
    waitress
    selenium
    func-timeout
    requests
    websockets
    xvfbwrapper
  ];
  pyinput = [ 
    pydep 
    chromium
    chromedriver
  ];
  extrainputs = [
    chromium
    chromedriver
    xvfb-run
  ];
in 
buildPythonPackage rec {
  pname = "FlareSolverr";
  version = "3.0.2";
  format = "other";

  pythonPath = [ python3 ];
  nativeBuildInputs = [ wrapPython makeWrapper ] ++ extrainputs ;
  propagatedBuildInputs = pyinput ++ extrainputs; 

  src = fetchFromGitHub {
    owner = "FlareSolverr";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-zpeJf1CaQ4bsncZz44sH+tFKddYrZf7YdNYL50d9GA4=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/src
    cp -r . $out/src
    #echo "${python3}/bin/python $out/src/src/flaresolverr.py" > $out/src/flare
    #chmod +x $out/src/flare
    makeWrapper "${python3}/bin/python" $out/bin/flaresolverr.py \
      --prefix PYTHONPATH : "$PYTHONPATH" --prefix PATH : ${lib.makeBinPath [chromium chromedriver xvfb-run]}

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

