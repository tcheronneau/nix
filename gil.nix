{ rustPlatform, 
  rustc, 
  cargo, 
  lib, 
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  name = "gil";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "eburghar";
    repo = "gil";
    rev = "${version}";
    hash = "sha256-tm/1ltzzjN7X2KCi8xTiWIlmveahhHQz0fLJxTsmenE=";

  };

  cargoSha256 = "sha256-qIeCi09+nYBW8D1fRozfQSQC1FBGEW6/XAaqlZ2YCDw=";
  nativeBuildInputs = [
    rustc
    cargo
  ];
  meta = with lib; {
    homepage = "https://github.com/eburghar/gil";
    description = "Command line tool to interact with Gitlab API from a git repository ";
    platforms = platforms.linux ;
    license = licenses.bsd2;
    maintainers = with maintainers; [ "tcheronneau" ];
  };
}
