{
  pkgs,
  homeDirectory,
  ...
}:

{
  home.packages = with pkgs; [
    awscli2
    ic
    kubelogin # Azure
    kubelogin-oidc
    lastpass-cli
    terraform
  ];

  home.sessionVariables = {
    XDG_CACHE_HOME = "${homeDirectory}/.cache";
    XDG_CONFIG_HOME = "${homeDirectory}/.config";
    XDG_DATA_HOME = "${homeDirectory}/.local/share";
    XDG_STATE_HOME = "${homeDirectory}/.local/state";
  };
}
