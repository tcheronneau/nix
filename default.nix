{ callPackage }:
rec {
    nvim = callPackage ./nvim {};
    scripts = callPackage ./mybash {};
    enpass = callPackage ./enpass {};
    sonarr = callPackage ./sonarr {};
    jackett = callPackage ./jackett {};
    seafile = callPackage ./seafile {};
    docker-sonarr = callPackage ./sonarr/docker.nix {};
    docker-jackett = callPackage ./jackett/docker.nix {};
}
