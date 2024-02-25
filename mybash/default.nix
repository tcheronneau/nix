{ pkgs, stdenv, bash }: 

stdenv.mkDerivation rec {
  pname = "mybash";
  version = "0.1.0";

  src = fetchGit {
    url = "gitea@git.mcth.fr:thomas/awesome-script.git";
    rev = "3675e190e71244c990d6bfc1fbbba2d867044945";
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
