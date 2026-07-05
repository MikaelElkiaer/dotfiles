{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  git, # INFO: Required to fetch submodules / resolve versions during build
  readline, # INFO: Required to compile the vendored lua-5.5.0 dependency
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "velvet";
  version = "0.3.0";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "Operdies";
    repo = "velvet";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qvjABq5Hr6kjygb7sxv4Tvf4g/L9blFQgFK+AYnZQBk=";
    fetchSubmodules = true;
  };

  # INFO: Added git to nativeBuildInputs to provide submodule/vcs build tools
  nativeBuildInputs = [
    git
  ];

  # INFO: Added readline to buildInputs because the vendored Lua submodule compiles with readline support
  buildInputs = [
    readline
  ];

  # INFO: Overrode PREFIX to install directly into the Nix store instead of /usr/local
  makeFlags = [
    "PREFIX=$(out)"
  ];

  # INFO: Lua's Makefile hardcodes the compile command as `gcc`.
  # This preBuild hook dynamically symlinks the standard cc compiler wrapper (clang on macOS, gcc on Linux)
  # to a temporary `gcc` binary and adds it to $PATH.
  preBuild = ''
    mkdir -p dev-bin
    ln -s "$(type -p cc)" dev-bin/gcc
    export PATH="$PWD/dev-bin:$PATH"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A scriptable terminal multiplexer";
    homepage = "https://github.com/Operdies/velvet";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "vv"; # Custom Fix: The actual binary compiled and installed by velvet is named `vv`
    platforms = lib.platforms.all;
  };
})
