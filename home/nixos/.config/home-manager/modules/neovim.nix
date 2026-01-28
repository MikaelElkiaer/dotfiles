{ config, pkgs, ... }:

{
  home.file = {
    ".config/nvim" = {
      recursive = true;
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Repositories/GitHub/nvim-config";
    };
  };

  home.packages = with pkgs; [
    neovim
    nvimpager
    # LSP
    bash-language-server
    dockerfile-language-server-nodejs
    gopls
    helm-ls
    jsonnet-language-server
    lua-language-server
    marksman # Markdown
    nil # Nix
    python313Packages.python-lsp-server
    vscode-langservers-extracted
    # roslyn-ls # WARN: Currently broken
    terraform-lsp
    typescript-language-server
    yaml-language-server
    # Linter
    hadolint
    htmlhint
    markdownlint-cli2
    # Formatter
    # csharpier #WARN: Currently broken
    mdformat
    nixfmt-rfc-style
    nodePackages.js-beautify
    prettierd
    shfmt
    stylua
    taplo # TOML
    xmlformat
    # Treesitter
    gcc # needed for auto install
    tree-sitter
    # DAP
    delve # Go
  ];
}
