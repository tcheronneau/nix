{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "aiac";
  version = "v1.0.0";
  src = fetchFromGitHub {
    owner = "gofireflyio";
    repo = "aiac";
    rev = "${version}";
    hash = "sha256-ZZXOPy3UKYLL7cE1YTYImJBk0CemWklwE8L0ixhzvcA=";
  };

  vendorHash = "sha256-6Pin/YWzj2ZbuvtFgxnoVQIg+zoz/CZZ/WDOIp9QTuc=";


  meta = with lib; {
    homepage = "https://aiac.co/";
    changelog = "https://github.com/gofireflyio/aiac/blob/${src.rev}/CHANGELOG.md";
    description = "Artificial Intelligence Infrastructure-as-Code Generator.";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.bsd2;
    maintainers = with maintainers; [ "tcheronneau" ];
  };
}
