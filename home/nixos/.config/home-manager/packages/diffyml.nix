{
  lib,
  buildGo127Module,
  fetchFromGitHub,
}:

buildGo127Module (finalAttrs: {
  pname = "diffyml";
  version = "1.8.3";

  src = fetchFromGitHub {
    owner = "szhekpisov";
    repo = "diffyml";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sIZujFk6SH+4e5iBmQkEy8gmaN9LCSU6mnrkB6FHqYo=";
  };

  vendorHash = "sha256-vjGhS7nhjXlms1ZsRG6Qy/7ategUIgwiBwk943cz9Lk=";

  ldflags = [
    # WARN: Might cause issues with anti-virus
    # "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
    "-X=main.commit=${finalAttrs.src.rev}"
  ];

  meta = {
    description = "A fast, structural YAML diff tool — in a single-dependency binary";
    homepage = "https://github.com/szhekpisov/diffyml";
    changelog = "https://github.com/szhekpisov/diffyml/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "diffyml";
  };

  # WARN: Build only main package, since others are currently failing tests
  subPackages = [ "." ];
})
