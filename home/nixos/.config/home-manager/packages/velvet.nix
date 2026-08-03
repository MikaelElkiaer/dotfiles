{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  git, # INFO: Required to fetch submodules / resolve versions during build
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "velvet";
  version = "0.4.0";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "Operdies";
    repo = "velvet";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2M9yXRuD4a+CHwyUtgLmLBudLunufU7cDCKo4clbGWU=";
    fetchSubmodules = true;
  };

  # INFO: Added git to nativeBuildInputs to provide submodule/vcs build tools
  nativeBuildInputs = [
    git
  ];

  # INFO: Overrode PREFIX to install directly into the Nix store instead of /usr/local
  makeFlags = [
    "PREFIX=$(out)"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A scriptable terminal multiplexer";
    homepage = "https://github.com/Operdies/velvet";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "vv"; # INFO: The actual binary compiled and installed by velvet is named `vv`
    platforms = lib.platforms.all;
  };
})
