local wezterm = require 'wezterm'

return {
  color_scheme = "tokyonight",
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
    '[^ \'"]{3,}'
  }
}
