local wezterm = require("wezterm")
local config = wezterm.config_builder()

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local pane = tab.active_pane
	local title = pane.title
	if title == "nvim" then
		return {
			{ Text = wezterm.nerdfonts.dev_vim .. " " },
			{ Text = string.gsub(pane.current_working_dir, "(.*[/\\])(.*)", "%2") },
		}
	end
end)

config.color_scheme = "Gruvbox dark, hard (base16)"
config.colors = {
	cursor_fg = wezterm.color.get_default_colors().background,
}
config.font = wezterm.font("Noto Sans Mono")
config.font_size = 10
config.hide_tab_bar_if_only_one_tab = true
config.unix_domains = {
	{
		name = "workstation",
	},
}
config.default_gui_startup_args = { "connect", "unix" }
config.quick_select_patterns = {
	"['\"`][^'\"`]{2,}['\"`]",
}
config.warn_about_missing_glyphs = false
config.window_frame = {
	font_size = 10,
}

return config
