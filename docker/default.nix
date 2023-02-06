{ dockerTools, runtimeShell }:



dockerTools.buildImage{
  name = "mcth/base";
  created = "now";
  tag = "latest";
  created = "now";
  runAsRoot = ''
    #!${runtimeShell}
    ${dockerTools.shadowSetup}
    groupadd -g 1005 -r anybody
    useradd -u 1005 -r -g anybody anybody
    mkdir -p /config
    chown -R anybody:anybody /config
  '';
}
