local map_prefix = "<C-x>"
require("velvet.presets.dwm").setup()

vv.options.theme = require("velvet.themes").gruvbox.dark

local keymap = require("velvet.keymap")
local lazygit_popup = require("lazygit_popup")
keymap:set("<C-x>G", lazygit_popup.toggle, { description = "Toggle lazygit popup in current folder" })

-- Disable DWM's default status bar and reserve 1 row at the bottom
local dwm = require("velvet.layout.dwm")
dwm.set_status(false)
dwm.reserve(0, 0, 1, 0)

-- Setup custom tmux-like status bar
require("statusbar_addon").setup()
