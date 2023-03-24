{ lib
, buildPythonPackage
, fetchPypi
, autobahn
, mock
, twisted
, python3
}:

buildPythonPackage rec {
  pname = "magic-wormhole-transit-relay";
  version = "0.2.1";

  src = /home/thomas/Projects/github/magic-wormhole-transit-relay;
  #src = fetchPypi {
  #  inherit pname version;
  #  sha256 = "0ppsx2s1ysikns1h053x67z2zmficbn3y3kf52bzzslhd2s02j6b";
  #};

  propagatedBuildInputs = [ autobahn twisted ];
  installPhase = ''
    runHook preInstall
    mkdir -p $out
    ${python3}/bin/python setup.py install --root=$out
    runHook postInstall
  '';

  checkInputs = [ mock twisted ];

  doCheck = false;
  #checkPhase = ''
  #  trial -j$NIX_BUILD_CORES wormhole_transit_relay
  #'';


  meta = with lib; {
    description = "Transit Relay server for Magic-Wormhole";
    homepage = "https://github.com/magic-wormhole/magic-wormhole-transit-relay";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
