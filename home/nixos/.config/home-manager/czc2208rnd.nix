{ config, nixgl, pkgs, ... }:

{
  home.packages = [
    (config.lib.nixGL.wrap pkgs.alacritty)
  ];
  nixGL.packages = nixgl.packages;
  targets.genericLinux.enable = true;
  xdg.enable = true;
}
