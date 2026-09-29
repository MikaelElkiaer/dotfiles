{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "code-review-graph";
  version = "2.3.9";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tirth8205";
    repo = "code-review-graph";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UiQg1ygebw6PePJVHNNOUsL6buw1/oMzX34jloui9Bg=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"tree-sitter-language-pack>=0.3.0,<1"' '"tree-sitter-language-pack>=0.3.0"'

    substituteInPlace code_review_graph/parser.py \
      --replace-fail 'env=_parser_probe_env(),' 'env=dict(os.environ, PYTHONPATH=os.pathsep.join(sys.path)),'
  '';

  build-system = [
    python3Packages.hatchling
  ];

  dependencies = with python3Packages; [
    anyio
    fastmcp
    mcp
    networkx
    pyyaml
    tomli
    tree-sitter
    tree-sitter-language-pack
    watchdog
  ];

  optional-dependencies = with python3Packages; {
    all = [
      code-review-graph
    ];
    browser-test = [
      playwright
      pytest-playwright
    ];
    communities = [
      igraph
    ];
    dev = [
      mypy
      pytest
      pytest-asyncio
      pytest-cov
      ruff
      tomli
    ];
    embeddings = [
      numpy
      sentence-transformers
    ];
    enrichment = [
      jedi
    ];
    eval = [
      matplotlib
      pyyaml
    ];
    google-embeddings = [
      google-genai
    ];
    wiki = [
      ollama
    ];
  };

  pythonImportsCheck = [
    "code_review_graph"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Local-first code intelligence graph for MCP and CLI. Builds a persistent map of your codebase so AI coding tools read only what matters, with benchmarked context reductions on reviews and large-repo workflows";
    homepage = "https://github.com/tirth8205/code-review-graph";
    changelog = "https://github.com/tirth8205/code-review-graph/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "code-review-graph";
  };
})
