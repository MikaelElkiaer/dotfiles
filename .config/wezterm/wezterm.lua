local wezterm = require 'wezterm'

return {
  color_scheme = "Gruvbox dark, hard (base16)",
  colors = {
    cursor_fg = wezterm.color.get_default_colors().background,
  },
  font = wezterm.font 'Noto Sans Mono',
  font_size = 10,
  hide_tab_bar_if_only_one_tab = true,
  
  unix_domains = {
    {
      name = 'workstation',
    }
  },

  default_gui_startup_args = {'connect', 'unix'},
  quick_select_patterns = {
    '[\'"`][^\'"`]{2,}[\'"`]'
  },

  window_frame = {
    font_size = 10,
  }
}
