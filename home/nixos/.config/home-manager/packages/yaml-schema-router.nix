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

  subPackages = [ "cmd/yaml-schema-router" ];

  buildPhase = ''
    runHook preBuild

    echo "Compiling yaml-schema-router directly..."
    export GOCACHE=$TMPDIR/go-cache

    # Force Go to build the binary in our current working directory
    go build -o yaml-schema-router-bin -ldflags="-s -w" ./cmd/yaml-schema-router

    runHook postBuild
  '';

  # We manually create the bin folder and move our explicit binary into it
  installPhase = ''
    runHook preInstall

    echo "Installing binary to $out/bin..."
    mkdir -p $out/bin
    cp yaml-schema-router-bin $out/bin/yaml-schema-router

    runHook postInstall
  '';
})
