{ lib, fetchFromGitHub, buildPythonPackage, python3, python3Packages, wrapPython, makeWrapper, chromedriver, chromium, xvfb-run }:
let 
  python = let 
    packageOverrides = prev: final: {
      selenium = final.selenium.overridePythonAttrs (old: {
        src = fetchFromGitHub {
          owner = "SeleniumHQ";
          repo = "selenium";
          rev = "refs/tags/selenium-4.8.0";
          hash = "sha256-YTi6SNtTWuEPlQ3PTeis9osvtnWmZ7SRQbne9fefdco=";
        };
        postInstall = ''
          install -Dm 755 ../rb/lib/selenium/webdriver/atoms/getAttribute.js $out/${python3Packages.python.sitePackages}/selenium/webdriver/remote/getAttribute.js
          install -Dm 755 ../rb/lib/selenium/webdriver/atoms/isDisplayed.js $out/${python3Packages.python.sitePackages}/selenium/webdriver/remote/isDisplayed.js
        '';
      });
    }; in python3.override { inherit packageOverrides; };
  pydep = with python.pkgs; [
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

  pythonPath = [ python ];
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
    makeWrapper "${python}/bin/python" $out/bin/flaresolverr \
      --add-flags "$out/src/src/flaresolverr.py" \
      --prefix PYTHONPATH : "$PYTHONPATH" \
      --prefix PYTHONPATH : "${lib.makeBinPath [chromium chromedriver xvfb-run]}" \
      --prefix PATH : ${lib.makeBinPath [chromium chromedriver xvfb-run]}
      

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

