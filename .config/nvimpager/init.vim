lua << EOF
vim.opt.ignorecase = true                       -- ignore case in search patterns
vim.opt.termguicolors = true                    -- set term gui colors (most terminals support this)
vim.opt.cursorline = true                       -- highlight the current line
vim.opt.smartcase = true                        -- smart case
vim.opt.wrap = true                             -- display lines as one long line
vim.g.tokyonight_style = "night"
EOF
set runtimepath+=~/.local/share/nvim/site/pack/packer/start/tokyonight.nvim
colorscheme tokyonight
