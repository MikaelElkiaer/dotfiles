{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "yaml-schema-router";
  version = "0-unstable-2026-10-01";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    # WARN: Using fork while waiting for https://github.com/tepea-code/yaml-schema-router/pull/4
    owner = "mikaelelkiaer";
    repo = "yaml-schema-router";
    rev = "d73ccf7f920976251692b85264d575b1d5161d7e";
    hash = "sha256-b3aWOt+k3OI/83Otpuodba+Pefrmr5U7WpE1d6EcP6s=";
  };

  vendorHash = null;

  ldflags = [ "-s" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Content-based JSON schema routing for YAML LSP (Neovim/Helix/Emacs";
    homepage = "https://github.com/traiproject/yaml-schema-router";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "yaml-schema-router";
  };
})
