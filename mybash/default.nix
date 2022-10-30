{ pkgs, stdenv, bash }: 

stdenv.mkDerivation rec {
  pname = "mybash";
  version = "0.1.0";

  src = fetchGit {
    url = "git@gitlab.mcth.fr:thomas/awesome-script.git";
    rev = "d689703ffd4b0b4db52948453c4c8724083c2482";
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
    mv bash/cheat.sh $out/bin/
    mv bash/reschedule.sh $out/bin/reschedule
  '';
}
