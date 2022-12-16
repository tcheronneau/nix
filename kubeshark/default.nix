#{ lib, buildGoModule, fetchFromGitHub, installShellFiles, makeWrapper, stdenv, go, bash }:
#
#stdenv.mkDerivation rec {
#  pname = "kubeshark";
#  version = "37.0";
#  src = fetchFromGitHub {
#    owner = "kubeshark";
#    repo = "kubeshark";
#    rev = "${version}";
#    hash = "sha256-Js5X14i5rZO6OOJud4Yw6Nh15wblGaqkRGYEhZswgDE=";
#  };
#  nativeBuildInputs = [ makeWrapper go bash];
#  preInstall = ''
#    mkdir -p $out/share/go
#  '';
#  makeFlags = [
#    "VER=${version}"
#    "SHELL=${bash}/bin/bash"
#    ".DEFAULT_GOAL=cli"
#    "PREFIX=${placeholder "out"}"
#    "GOPATH=${placeholder "out"}/share/go"
#    "GOCACHE=${placeholder "out"}/go-cache"
#  ];
#  installPhase = ''
#    mkdir -p $out/bin
#    mv bin/* $out/bin/
#  '';
#
#  meta = with lib; {
#    homepage = "https://kubeshark.co/";
#    changelog = "https://github.com/kubeshark/kubeshark/blob/${src.rev}/CHANGELOG.md";
#    description = "The API traffic viewer for Kubernetes providing deep visibility into all API traffic and payloads going in, out and across containers and pods inside a Kubernetes cluster. Think TCPDump and Wireshark re-invented for Kubernetes";
#    platforms = platforms.linux ++ platforms.darwin;
#    license = licenses.bsd2;
#    maintainers = with maintainers; [ "tcheronneau" ];
#  };
#}
{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "kubeshark";
  version = "37.0";
  src = fetchFromGitHub {
    owner = "kubeshark";
    repo = "kubeshark";
    rev = "${version}";
    hash = "sha256-Js5X14i5rZO6OOJud4Yw6Nh15wblGaqkRGYEhZswgDE=";
  };

  vendorHash = "sha256-6uctdJ2+8KqHMLHQPkBSsTkqndTp58XDbLHKQqTdEQE=";
  modRoot = "./cli";


  meta = with lib; {
    homepage = "https://kubeshark.co/";
    changelog = "https://github.com/kubeshark/kubeshark/blob/${src.rev}/CHANGELOG.md";
    description = "The API traffic viewer for Kubernetes providing deep visibility into all API traffic and payloads going in, out and across containers and pods inside a Kubernetes cluster. Think TCPDump and Wireshark re-invented for Kubernetes";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.bsd2;
    maintainers = with maintainers; [ "tcheronneau" ];
  };
}
