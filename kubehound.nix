{ buildGoModule, fetchFromGitHub, lib }:
buildGoModule rec {
  pname = "kubehound";
  version = "1.4.0";
  src = fetchFromGitHub {
    owner = "DataDog";
    repo = "KubeHound";
    rev = "v${version}";
    hash = "sha256-YbCIjjold7VmvRhXP1QOrhMq4hqJdjuR7zb5o+L0kuw=";
  };

  checkPhase = "";
  vendorHash = "sha256-TsyoMOD8XBExMgRLfEqd8fKu5VIX6igWMhc6dYWF5/Q=";


  meta = with lib; {
    homepage = "https://kubehound.dev/";
    description = "A task runner / simpler Make alternative written in Go ";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.bsd2;
    maintainers = with maintainers; [ tcheronneau ];
  };
}
