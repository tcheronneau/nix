{ pkgs, stdenv, bash }: 

stdenv.mkDerivation rec {
  pname = "mybash";
  version = "0.1.0";

  src = fetchGit {
    url = "git@gitlab.mcth.fr:thomas/awesome-script.git";
    rev = "481895e993eb17e60a7ba42d787a9dbaafddc453";
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
  '';
}
