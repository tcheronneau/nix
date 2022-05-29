{ pkgs, stdenv, bash }: 

stdenv.mkDerivation rec {
  pname = "mybash";
  version = "0.1.0";

  src = fetchGit {
    url = "git@gitlab.mcth.fr:thomas/awesome-script.git";
    rev = "f20cff4231c58c674d5b03794a3f6ae625204d98";
  };

  buildInputs = [
    bash
  ];

  configurePhase = ''
    ls -l 
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv bash/urlencode $out/bin/
    mv bash/switchvault $out/bin/
  '';
}
