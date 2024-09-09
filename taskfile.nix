{ buildGoModule, fetchFromGitHub, lib }:
buildGoModule rec {
  pname = "taskfile";
  version = "3.39.0";
  src = fetchFromGitHub {
    owner = "go-task";
    repo = "task";
    rev = "v${version}";
    hash = "sha256-/F3APfIOOirLah4ZkzoJmsjlbe6R2Xag43hMjUM44i0=";
  };

  checkPhase = "";
  vendorHash = "sha256-P9J69WJ2C2xgdU9xydiaY8iSKB7ZfexLNYi7dyHDTIk=";


  meta = with lib; {
    homepage = "https://taskfile.dev/";
    description = "A task runner / simpler Make alternative written in Go ";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.bsd2;
    maintainers = with maintainers; [ tcheronneau ];
  };
}
