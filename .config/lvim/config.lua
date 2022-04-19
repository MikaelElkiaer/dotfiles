--[[
lvim is the global options object

Linters should be
filled in as strings with either
a global executable or a path to
an executable
]]
-- THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT

-- general
lvim.log.level = "warn"
lvim.format_on_save = false
lvim.colorscheme = "dracula"

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"
-- add your own keymapping
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
-- unmap a default keymapping
-- lvim.keys.normal_mode["<C-Up>"] = false
-- edit a default keymapping
-- lvim.keys.normal_mode["<C-q>"] = ":q<cr>"

-- Change Telescope navigation to use j and k for navigation and n and p for history in both input and normal mode.
-- we use protected-mode (pcall) just in case the plugin wasn't loaded yet.
-- local _, actions = pcall(require, "telescope.actions")
-- lvim.builtin.telescope.defaults.mappings = {
--   -- for input mode
--   i = {
--     ["<C-j>"] = actions.move_selection_next,
--     ["<C-k>"] = actions.move_selection_previous,
--     ["<C-n>"] = actions.cycle_history_next,
--     ["<C-p>"] = actions.cycle_history_prev,
--   },
--   -- for normal mode
--   n = {
--     ["<C-j>"] = actions.move_selection_next,
--     ["<C-k>"] = actions.move_selection_previous,
--   },
-- }

-- Use which-key to add extra bindings with the leader-key prefix
-- lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
-- lvim.builtin.which_key.mappings["t"] = {
--   name = "+Trouble",
--   r = { "<cmd>Trouble lsp_references<cr>", "References" },
--   f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
--   d = { "<cmd>Trouble document_diagnostics<cr>", "Diagnostics" },
--   q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
--   l = { "<cmd>Trouble loclist<cr>", "LocationList" },
--   w = { "<cmd>Trouble workspace_diagnostics<cr>", "Wordspace Diagnostics" },
-- }

-- TODO: User Config for predefined plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.notify.active = true
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.show_icons.git = 0
lvim.builtin.lualine.active = true
lvim.builtin.dap.active = true
lvim.builtin.terminal.active = true

-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "c",
  "c_sharp",
  "javascript",
  "json",
  "lua",
  "python",
  "typescript",
  "tsx",
  "css",
  "rust",
  "java",
  "yaml",
}

lvim.builtin.treesitter.ignore_install = { "" }
lvim.builtin.treesitter.highlight.enabled = true

-- generic LSP settings

-- ---@usage disable automatic installation of servers
-- lvim.lsp.automatic_servers_installation = false

-- ---@usage Select which servers should be configured manually. Requires `:LvimCacheReset` to take effect.
-- See the full default list `:lua print(vim.inspect(lvim.lsp.override))`
-- vim.list_extend(lvim.lsp.override, { "pyright" })

-- ---@usage setup a server -- see: https://www.lunarvim.org/languages/#overriding-the-default-configuration
-- local opts = {} -- check the lspconfig documentation for a list of all possible options
-- require("lvim.lsp.manager").setup("pylsp", opts)

-- -- you can set a custom on_attach function that will be used for all the language servers
-- -- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
-- lvim.lsp.on_attach_callback = function(client, bufnr)
--   local function buf_set_option(...)
--     vim.api.nvim_buf_set_option(bufnr, ...)
--   end
--   --Enable completion triggered by <c-x><c-o>
--   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
-- end

-- -- set a formatter, this will override the language server formatting capabilities (if it exists)
-- local formatters = require "lvim.lsp.null-ls.formatters"
-- formatters.setup {
--   { command = "black", filetypes = { "python" } },
--   { command = "isort", filetypes = { "python" } },
--   {
--     -- each formatter accepts a list of options identical to https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#Configuration
--     command = "prettier",
--     ---@usage arguments to pass to the formatter
--     -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
--     extra_args = { "--print-with", "100" },
--     ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
--     filetypes = { "typescript", "typescriptreact" },
--   },
-- }

-- -- set additional linters
-- local linters = require "lvim.lsp.null-ls.linters"
-- linters.setup {
--   { command = "flake8", filetypes = { "python" } },
--   {
--     -- each linter accepts a list of options identical to https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#Configuration
--     command = "shellcheck",
--     ---@usage arguments to pass to the formatter
--     -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
--     extra_args = { "--severity", "warning" },
--   },
--   {
--     command = "codespell",
--     ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
--     filetypes = { "javascript", "python" },
--   },
-- }

-- Additional Plugins
lvim.plugins = {
  { "Mofiqul/dracula.nvim" },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    module = "nvim-treesitter-textobjects",
    after = "nvim-treesitter",
    config = function()
      require("custom.plugins.treesitter-textobjects").setup()
    end,
  },
  {
    "phaazon/hop.nvim",
    as = "hop",
    config = function()
      require 'hop'.setup()
    end,
  },
  {
    "chaoren/vim-wordmotion",
  },
  {
    "Pocco81/AutoSave.nvim",
    config = function()
      require 'autosave'.setup {
        conditions = {
          filename_is_not = { "config.lua" }
        }
      }
    end
  },
  { "wellle/targets.vim" },
  {
    "Hoffs/omnisharp-extended-lsp.nvim",
    requires = { { "nvim-telescope/telescope.nvim" } },
  },
  {
    "vim-test/vim-test"
  },
  {
    "francoiscabrol/ranger.vim",
    requires = { { "rbgrouleff/bclose.vim" } }
  },
  {
    "nvim-telescope/telescope-dap.nvim",
    requires = { { "mfussenegger/nvim-dap" }, { "nvim-telescope/telescope.nvim" } },
    config = function()
      require('telescope').load_extension('dap')
    end
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    requires = { { "mfussenegger/nvim-dap", "nvim-treesitter/nvim-treesitter" } },
    config = function()
      require("nvim-dap-virtual-text").setup()
    end
  },
  { "lukas-reineke/indent-blankline.nvim" }
}

-- Autocommands (https://neovim.io/doc/user/autocmd.html)
-- lvim.autocommands.custom_groups = {
--   { "BufWinEnter", "*.lua", "setlocal ts=8 sw=8" },
-- }

vim.opt.relativenumber = true
vim.opt.wrap = true
vim.g.wordmotion_prefix = "<BS>"
--vim.g.did_load_filetypes = 1
vim.g["test#csharp#runner"] = "dotnettest"
vim.g["test#strategy"] = "neovim"
vim.g["test#neovim#term_position"] = "below 15"
vim.g.ranger_map_keys = 0

-- lualine
if lvim.builtin.lualine.active then
  require('lualine').setup {
    options = {
      theme = 'dracula-nvim'
    }
  }
end

-- nvim-treesitter-textobjects
require 'nvim-treesitter.configs'.setup {
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]m"] = "@function.outer",
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
      },
    },
  },
}

-- nvim-dap
local dap = require("dap")
dap.adapters.netcoredbg = {
  type = 'executable',
  command = '/usr/bin/netcoredbg',
  args = { '--interpreter=vscode' }
}
dap.configurations.cs = {
  {
    type = "netcoredbg",
    name = "launch - netcoredbg",
    request = "launch",
    program = function()
      return vim.fn.input('Path to dll', vim.fn.getcwd(), 'file')
    end,
  },
  {
    type = "netcoredbg",
    name = "attach - netcoredbg",
    request = "attach",
    processId = require('dap.utils').pick_process,
  },
}

-- toggleterm
-- local Terminal = require('toggleterm.terminal').Terminal
-- local default_terminal = Terminal:new({
--   direction = "horizontal",
--   hidden = true
-- })

-- function DefaultTerminalToggle()
--   default_terminal:toggle()
-- end

-- lspconfig
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "efm", "omnisharp" })

local lspconfig = require "lspconfig"
local pid = vim.fn.getpid()
local on_attach = require("lvim.lsp").common_on_attach
local capabilities = require("lvim.lsp").common_capabilities()

lspconfig.omnisharp.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "cs" },
  handlers = {
    ["textDocument/definition"] = require('omnisharp_extended').handler,
  },
  cmd = { "/usr/bin/omnisharp", "--languageserver", "--hostPID", tostring(pid) },
  root_dir = function(fname)
    return vim.fn.getcwd()
  end,
}

lspconfig.efm.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "markdown" },
  init_options = { documentFormatting = false },
  settings = {
    rootMarkers = { ".git/" },
    languages = {
      markdown = {
        {
          lintCommand = "markdownlint -s",
          lintStdin = true,
          lintFormats = { "%f:%l %m", "%f:%l:%c %m", "%f: %l: %m" }
        }
      }
    }
  }
}

local opts = { noremap = true, silent = true }
local map = vim.api.nvim_set_keymap
map("n", "gw", "<cmd>HopWord<cr>", opts)
map("n", "gl", "<cmd>HopLine<cr>", opts)
map("n", "gf", "<cmd>HopChar1<cr>", opts)
map("n", "g/", "<cmd>HopPattern<cr>", opts)
lvim.builtin.which_key.mappings["t"] = {
  name = "Test",
  n = { "<cmd>TestNearest<CR>", "Nearest" },
  f = { "<cmd>TestFile<CR>", "File" },
  s = { "<cmd>TestSuite<CR>", "Suite" },
  l = { "TestLast<CR>", "Last" },
  v = { "<cmd>TestVisit<CR>-\\><C-n><C-w>l", "Visit" }
}
lvim.builtin.which_key.mappings["r"] = { "<cmd>RangerCurrentFile<CR>", "Ranger file" }
