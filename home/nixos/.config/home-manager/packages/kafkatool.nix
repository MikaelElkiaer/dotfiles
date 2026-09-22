{
  lib,
  buildGoModule,
  fetchFromGitHub,
  libpcap,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "kafkatool";
  version = "3.2.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "mimir";
    tag = "mimir-${finalAttrs.version}";
    hash = "sha256-/i4nF4YGKvNRt/JkB4pOIIrXvZhPTvM8GEePEGP7hY8=";
  };

  vendorHash = null;

  subPackages = [ "tools/kafkatool" ];

  buildInputs = [
    libpcap
  ];

  ldflags = [ "-s" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Grafana Mimir provides horizontally scalable, highly available, multi-tenant, long-term storage for Prometheus";
    homepage = "https://github.com/grafana/mimir";
    changelog = "https://github.com/grafana/mimir/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "kafkatool";
  };
})
