{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "yaml-schema-router";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "traiproject";
    repo = "yaml-schema-router";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GFe5NPW8nxv+bQsG5G26WCf2Z6qrW1WAZBMWFZD8MFI=";
  };

  vendorHash = null;

  ldflags = [ "-s" ];

  meta = {
    description = "Content-based JSON schema routing for YAML LSP (Neovim/Helix/Emacs";
    homepage = "https://github.com/traiproject/yaml-schema-router";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "yaml-schema-router";
  };
})
