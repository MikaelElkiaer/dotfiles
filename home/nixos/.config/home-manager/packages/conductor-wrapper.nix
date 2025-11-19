{ pkgs ? import <nixpkgs> {} }:
{
  conductor = pkgs.callPackage ./conductor.nix {};
}
