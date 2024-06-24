{ config, pkgs, ... }:

{
  home.file = {
    ".config/nvim" = {
      recursive = true;
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Repositories/GitHub/nvim-config";
    };
  };

  home.packages = [
    pkgs.neovim
    # LSP
    pkgs.bash-language-server
    pkgs.dockerfile-language-server-nodejs
    pkgs.gopls
    pkgs.helm-ls
    # pkgs.json-lsp
    pkgs.lua-language-server
    pkgs.omnisharp-roslyn
    pkgs.yaml-language-server
    # Linter
    pkgs.hadolint
    pkgs.nodePackages.jsonlint
    pkgs.vale
    # Formatter
    pkgs.mdformat
    pkgs.shfmt
    pkgs.stylua
    pkgs.taplo
    pkgs.xmlformat
    # Treesitter
    pkgs.tree-sitter
  ];
}
