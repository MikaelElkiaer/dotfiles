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
  home.packages = with pkgs; [
    (config.lib.nixGL.wrap alacritty)
    keepassxc
    minikube
  ];
  nixGL.packages = nixgl.packages;
  targets.genericLinux.enable = true;
  xdg.enable = true;
}
