local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- automatically check for plugin updates
  checker = { enabled = false },
  defaults = {
    lazy = false,
    -- always use the latest git commit
    version = false,
  },
  install = { colorscheme = { "gruvbox" } },
  change_detection = {
    -- automatically check for config file changes and reload the ui
    enabled = false,
    notify = false,
  },
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
  spec = {
    {
      {
        "ellisonleao/gruvbox.nvim",
        config = function(_, opts)
          require("gruvbox").setup(opts)
          vim.o.background = "dark"
          vim.cmd([[colorscheme gruvbox]])
        end,
        opts = {
          bold = false,
          italic = {
            strings = false,
            comments = false,
            operators = false,
            folds = false,
          },
          contrast = "hard",
          invert_tabline = true,
          transparent_mode = true,
        },
      },
      {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        -- TODO: Enable after https://github.com/lucc/nvimpager/pull/98
        enabled = false,
        main = "nvim-treesitter.configs",
        opts = {
          ensure_installed = {
            "markdown",
          },
          highlight = { enable = true },
          indent = { enable = true },
        },
      },
    },
  },
})
