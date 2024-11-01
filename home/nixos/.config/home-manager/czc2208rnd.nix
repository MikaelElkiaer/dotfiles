{ nixgl, pkgs, ... }:

{
  home.packages = [
    pkgs.alacritty
    pkgs.microsoft-edge
  ];
  nixGL.packages = nixgl.packages;
  targets.genericLinux.enable = true;
  xdg.enable = true;
}
