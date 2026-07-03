{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "diffyml";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "szhekpisov";
    repo = "diffyml";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bfFerbjpwQuTCnGKfqUj3ydf1xBdNoP+qH7UTmtZvTk=";
  };

  vendorHash = "sha256-QE/EwVzMqUO24ZAl0WBibGx6x0kNo1AUTZtfnQvX50k=";

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
