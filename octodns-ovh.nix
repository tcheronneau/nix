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
, ovh
, python3Packages
}:

let
  octodns = python3Packages.callPackage ./octodns.nix {};
in

buildPythonApplication rec {
  pname = "octodns-ovh";
  version = "0.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-0hwJHn4m70Rh0e2XNxVpAUBwQwuWkzG5qApPYhTW3dg=";
  };
  doCheck = false;

  propagatedBuildInputs = [ pyyaml dnspython fqdn idna natsort python-dateutil setuptools six octodns ovh ];

  meta = with lib; {
    description = "Tools for managing DNS across multiple providers";
    homepage = "https://github.com/octodns/octodns";
    license = licenses.mit;
    maintainers = with maintainers; [ tcheronneau ];
  };
}
