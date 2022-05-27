{ pkgs ? import <nixpkgs> {} }:

let
  self.mcth = rec {

    nvim = pkgs.callPackage ./nvim { };
    scripts = pkgs.callPackage ./mybash { };
  };
in pkgs // self
