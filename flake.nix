{
  description = "My personal Neovim configuration";
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
    #flake-utils.url = "github:numtide/flake-utils";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };
  outputs = { self, ... } @inputs : {
    packages.x86_64-linux = (import ./packages.nix inputs);
  };
}
