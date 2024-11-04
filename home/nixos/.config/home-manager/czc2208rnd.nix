{ config, nixgl, pkgs, ... }:

{
  home.packages = [
    pkgs.microsoft-edge
    (config.lib.nixGL.wrap pkgs.alacritty)
  ];
  nixGL.packages = nixgl.packages;
  targets.genericLinux.enable = true;
  xdg.enable = true;
}
