{
  config,
  lib,
  pkgs,
  ...
}:

let
  vaultAddrSet =
    config.home.sessionVariables ? VAULT_ADDR && config.home.sessionVariables.VAULT_ADDR != "";
in
{
  config = lib.mkIf vaultAddrSet {
    home.packages = with pkgs; [
      vault-bin
    ];
    systemd.user = {
      services = {
        login-status-vlt = {
          Install.WantedBy = [ "default.target" ];
          Service = {
            Environment = [
              "PATH=${
                lib.makeBinPath [
                  pkgs.bash
                  pkgs.vault-bin
                ]
              }:/usr/local/bin:/usr/bin"
              "VAULT_ADDR=${config.home.sessionVariables.VAULT_ADDR}"
            ];
            ExecStart = "${config.home.homeDirectory}/bin/login-status-vlt";
          };
          Unit.Description = "Set login status for Vault";
        };
      };
      timers = {
        login-status-vlt = {
          Install.WantedBy = [ "timers.target" ];
          Timer = {
            OnCalendar = "*-*-* *:*:00";
            Persistent = true;
          };
          Unit.Description = "Run login status for Vault every minute";
        };
      };
    };
  };
}
