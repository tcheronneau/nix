{ dockerTools, runtimeShell }:



dockerTools.buildImage{
  name = "mcth/base";
  created = "now";
  tag = "latest";
  runAsRoot = ''
    #!${runtimeShell}
    ${dockerTools.shadowSetup}
    groupadd -g 1005 -r everybody
    useradd -u 1005 -r -g everybody everybody
    mkdir -p /config
    chown -R everybody:everybody /config
  '';
  config = {
    User = "1005:1005";
  };
}
