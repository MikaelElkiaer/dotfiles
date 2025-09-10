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
    vscode-langservers-extracted
    lua-language-server
    marksman # Markdown
    nil # Nix
    # roslyn-ls # WARN: Currently broken
    terraform-lsp
    typescript-language-server
    yaml-language-server
    # Linter
    hadolint
    htmlhint
    markdownlint-cli2
    # Formatter
    csharpier
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
