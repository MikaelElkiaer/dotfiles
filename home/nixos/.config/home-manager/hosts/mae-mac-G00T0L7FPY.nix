{
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    awscli2
    ic
    kubelogin # Azure
    kubelogin-oidc
    lastpass-cli
  ];
}
