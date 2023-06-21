{ lib
, buildPythonApplication
, fetchPypi
, pyyaml
, dnspython
, fqdn
, natsort
, idna
, python-dateutil
, setuptools
, six
}:

buildPythonApplication rec {
  pname = "octodns";
  version = "1.0.0rc0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ohpvKTO+v+rl1fJf5rPAMnqzpkKC2A4fiR5tylhSiJ8=";
  };
  doCheck = false;

  propagatedBuildInputs = [ pyyaml dnspython fqdn idna natsort python-dateutil setuptools six ];

  meta = with lib; {
    description = "Tools for managing DNS across multiple providers";
    homepage = "https://github.com/octodns/octodns";
    license = licenses.mit;
    maintainers = with maintainers; [ tcheronneau ];
  };
}
