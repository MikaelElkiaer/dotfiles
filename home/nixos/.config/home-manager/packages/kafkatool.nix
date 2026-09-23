{
  lib,
  buildGoModule,
  fetchFromGitHub,
  libpcap,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "kafkatool";
  version = "distributed-6.3.0-weekly.413";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "mimir";
    tag = "mimir-${finalAttrs.version}";
    hash = "sha256-CAQL/55EODXjpRTd3+intAtTdwa3J+slHLynPscq+us=";
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
