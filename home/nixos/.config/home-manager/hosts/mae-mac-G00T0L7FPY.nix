{
  pkgs,
  homeDirectory,
  ...
}:

{
  home.packages = with pkgs; [
    ansible
    aws-iam-authenticator
    awscli2
    crane
    google-cloud-sdk
    grizzly # Grafana manager - with jsonnet support
    ic
    jsonnet
    jsonnet-bundler
    kubelogin # Azure
    kubelogin-oidc
    terraform
    vault-bin
    vault-medusa
    velero
  ];

  home.sessionVariables = {
    AWS_PROFILE = "netic-iam-mfa";
    GOOGLE_CLOUD_PROJECT="netic-code-assist";
    VAULT_ADDR = "https://vault.shared.k8s.netic.dk";
    XDG_CACHE_HOME = "${homeDirectory}/.cache";
    XDG_CONFIG_HOME = "${homeDirectory}/.config";
    XDG_DATA_HOME = "${homeDirectory}/.local/share";
    XDG_STATE_HOME = "${homeDirectory}/.local/state";
  };
}
