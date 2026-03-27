{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "kubectl-slice";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "patrickdappollonio";
    repo = "kubectl-slice";
    tag = "v${finalAttrs.version}";
    hash = "sha256-C9YxMP9MCKJXh3wQ1JoilpzI3nIH3LnsTeVPMzri5h8=";
  };

  vendorHash = "sha256-Lly8gGLkpBAT+h1TJNkt39b5CCrn7xuVqrOjl7RWX7w=";

  ldflags = [
    "-w"
    "-X=main.version=${finalAttrs.version}"
    "-extldflags"
    "-static"
  ];

  meta = {
    description = "Split multiple Kubernetes files into smaller files with ease. Split multi-YAML files into individual files";
    homepage = "https://github.com/patrickdappollonio/kubectl-slice";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "kubectl-slice";
  };
})
