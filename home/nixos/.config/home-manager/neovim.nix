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
    # LSP
    bash-language-server
    dockerfile-language-server-nodejs
    gopls
    helm-ls
    vscode-langservers-extracted
    lua-language-server
    marksman # Markdown
    nil # Nix
    roslyn-ls
    yaml-language-server
    # Linter
    hadolint
    markdownlint-cli2
    # Formatter
    csharpier
    mdformat
    nixfmt-rfc-style
    shfmt
    stylua
    taplo # TOML
    xmlformat
    # Treesitter
    gcc # needed for auto install
    tree-sitter
  ];
}
