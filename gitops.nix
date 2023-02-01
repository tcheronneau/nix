{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "weave-gitops";
  version = "v0.15.0";
  src = fetchFromGitHub {
    owner = "weaveworks";
    repo = "weave-gitops";
    rev = "${version}";
    hash = "sha256-m85uIgDte//p7TiZPJLUtAaLYsVWM/cQQgeDBRSSfmk=";
  };

  vendorHash = "sha256-hlxD9pwxrG0S8guqpit5yvboaVVT+2oFf2R0HRQSwME=";
  checkPhase = "";


  meta = with lib; {
    homepage = "https://weave-gitops.co/";
    changelog = "https://github.com/weaveworks/weave-gitops/blob/${src.rev}/CHANGELOG.md";
    description = "Weave GitOps OSS";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.bsd2;
    maintainers = with maintainers; [ "tcheronneau" ];
  };
}
