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
    pkgs.csharp-ls
    pkgs.dockerfile-language-server-nodejs
    pkgs.gopls
    pkgs.helm-ls
    pkgs.vscode-langservers-extracted
    pkgs.lua-language-server
    pkgs.marksman # Markdown
    pkgs.nil # Nix
    pkgs.omnisharp-roslyn
    pkgs.yaml-language-server
    # Linter
    pkgs.markdownlint-cli2
    # Formatter
    pkgs.csharpier
    pkgs.mdformat
    pkgs.nixfmt-rfc-style
    pkgs.shfmt
    pkgs.stylua
    pkgs.taplo # TOML
    pkgs.xmlformat
    # Treesitter
    pkgs.gcc # needed for auto install
    pkgs.tree-sitter
  ];
}
