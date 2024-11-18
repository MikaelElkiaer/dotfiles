{
  config,
  nixgl,
  pkgs,
  ...
}:

let
  dotHome = "${config.home.homeDirectory}/Repositories/GitHub/dotfiles/home/nixos";
in
{
  home.file = {
    ".config/alacritty" = {
      recursive = true;
      source = config.lib.file.mkOutOfStoreSymlink "${dotHome}/.config/alacritty";
    };
  };
  home.packages = [
    (config.lib.nixGL.wrap pkgs.alacritty)
    pkgs.keepassxc
    pkgs.minikube
  ];
  nixGL.packages = nixgl.packages;
  targets.genericLinux.enable = true;
  xdg.enable = true;
}
