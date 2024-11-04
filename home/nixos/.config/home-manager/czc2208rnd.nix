{ config, nixgl, pkgs, ... }:

{
  home.packages = [
    (config.lib.nixGL.wrap pkgs.alacritty)
    pkgs.minikube
  ];
  nixGL.packages = nixgl.packages;
  targets.genericLinux.enable = true;
  xdg.enable = true;
}
