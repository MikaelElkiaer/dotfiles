local map_prefix = "<C-x>"
require("velvet.presets.dwm").setup()

vv.options.theme = require("velvet.themes").gruvbox.dark

local keymap = require("velvet.keymap")
local lazygit_popup = require("lazygit_popup")
keymap:set("<C-x>G", lazygit_popup.toggle, { description = "Toggle lazygit popup in current folder" })
