{
  lib,
  stdenv,
  fetchFromGitea,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "velvet";
  version = "0.4.0";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "alexnlarsen";
    repo = "velvet";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2M9yXRuD4a+CHwyUtgLmLBudLunufU7cDCKo4clbGWU=";
    fetchSubmodules = true;
  };

  # INFO: Overrode PREFIX to install directly into the Nix store instead of /usr/local
  makeFlags = [
    "PREFIX=$(out)"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A scriptable terminal multiplexer";
    homepage = "https://codeberg.org/alexnlarsen/velvet";
    changelog = "https://codeberg.org/alexnlarsen/velvet/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "vv"; # INFO: The actual binary compiled and installed by velvet is named `vv`
    platforms = lib.platforms.all;
  };
})
