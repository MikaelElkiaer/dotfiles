{
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "docker-credential-ghcr-login";
  version = "main";

  src = fetchFromGitHub {
    owner = "mikaelelkiaer";
    repo = "docker-credential-ghcr-login";
    rev = "${version}";
    sha256 = "sha256-/2qLWbr/tyFk/gSYIUJ+A6VkNUH7v4+iUQhRalRgwVA=";
  };

  vendorHash = "sha256-hD9BmJI4wGr2bADy0x4PeabbhtLkClQoLRUFjPwaJao=";

  ldflags = [
    "-s"
    "-w"
    "-X main.VERSION=${version}"
  ];

  meta = {
    description = "Automagically auth to GitHub Container Registry via docker credential helper";
    mainProgram = "docker-credential-ghcr-login";
    homepage = "https://github.com/mikaelelkiaer/docker-credential-ghcr-login";
  };
}
