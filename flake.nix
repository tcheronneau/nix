{
  description = "My personal Neovim configuration";
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
    #flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, ... } @inputs : {
    packages.x86_64-linux = (import ./default.nix inputs);
  };
}
