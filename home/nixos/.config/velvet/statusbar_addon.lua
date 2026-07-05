local M = {}

local window = require("velvet.window")
local async = require("velvet.async")

local statusbar_win = nil
local ticker_id = nil

-- Resolve hostname once at load time to avoid blocking redraws
local hostname = os.getenv("HOSTNAME") or os.getenv("HOST")
if not hostname or hostname == "" then
	local f = io.popen("hostname")
	if f then
		hostname = f:read("*l")
		f:close()
	end
end
hostname = hostname or "localhost"

local function draw_statusbar()
	if not statusbar_win or not statusbar_win:valid() then
		return
	end

	local sz = vv.api.get_screen_geometry()
	-- Keep status bar at the very bottom row
	statusbar_win:set_geometry({ left = 1, top = sz.height, width = sz.width, height = 1 })

	statusbar_win:clear()
	-- Solid dark background matching modern status bars
	statusbar_win:set_background_color("black")
	statusbar_win:set_foreground_color("white")

	-- 1. Left Segment: Session/Server Name in Green (tmux style)
	local servername = vv.api.get_servername():upper()
	statusbar_win:set_cursor(1, 1)
	statusbar_win:set_background_color("green")
	statusbar_win:set_foreground_color("black")
	statusbar_win:draw(" [" .. servername .. "] ")

	-- Spacer
	statusbar_win:set_background_color("black")
	statusbar_win:set_foreground_color("white")
	statusbar_win:draw(" ")

	-- 2. Middle Segment: Window list (tmux style)
	local win_list = vv.api.get_windows()
	local focused_id = vv.api.get_focused_window()

	-- Filter only top-level process windows
	local process_wins = {}
	for _, id in ipairs(win_list) do
		if vv.api.window_is_valid(id) and not vv.api.window_is_lua(id) and vv.api.window_get_parent(id) == 0 then
			table.insert(process_wins, id)
		end
	end
	table.sort(process_wins)

	for idx, id in ipairs(process_wins) do
		local proc_name = vv.api.window_get_foreground_process_name(id) or "shell"
		proc_name = proc_name:gsub(".*/", "")

		local is_focused = (id == focused_id)
		local tab_text = string.format(" %d:%s%s ", idx, proc_name, is_focused and "*" or "")

		if is_focused then
			-- Highlighted active window (bright blue background)
			statusbar_win:set_background_color("bright_blue")
			statusbar_win:set_foreground_color("black")
		else
			-- Regular inactive window
			statusbar_win:set_background_color("bright_black")
			statusbar_win:set_foreground_color("white")
		end
		statusbar_win:draw(tab_text)

		-- Spacer
		statusbar_win:set_background_color("black")
		statusbar_win:set_foreground_color("white")
		statusbar_win:draw(" ")
	end

	-- 3. Right Segment: Hostname and Time (Right Aligned)
	local time_str = os.date("%Y-%m-%d %H:%M:%S")
	local right_text = string.format(" %s | %s ", hostname, time_str)

	local r_width = vv.api.string_display_width(right_text)
	local r_col = sz.width - r_width + 1

	-- Ensure we don't overwrite middle segment if screen is too small
	if r_col > statusbar_win:get_cursor().col then
		statusbar_win:set_cursor(r_col, 1)
		statusbar_win:set_background_color("bright_black")
		statusbar_win:set_foreground_color("white")
		statusbar_win:draw(right_text)
	end
end

local function ticker()
	draw_statusbar()
	ticker_id = vv.api.schedule_after(1000, ticker)
end

function M.setup()
	-- Close any existing statusbar to prevent duplicates on hot-reload
	if statusbar_win and statusbar_win:valid() then
		statusbar_win:close()
	end

	-- Create a new status bar window
	statusbar_win = window.create()
	statusbar_win:set_z_index(vv.z_hint.statusbar)
	statusbar_win:set_cursor_visible(false)
	statusbar_win:set_line_wrapping(false)

	-- Draw the initial status
	draw_statusbar()

	-- Register event handlers for live updates
	local events = vv.events.create_group("custom_statusbar", true)
	events.screen_resized = draw_statusbar
	events.window_created = draw_statusbar
	events.window_closed = draw_statusbar
	events.window_focus_changed = draw_statusbar

	-- Start the clock ticker
	if ticker_id then
		vv.api.schedule_cancel(ticker_id)
	end
	ticker()
end

-- Safe cleanup coroutine on config hot-reload
async.run(function()
	async.defer(function()
		if ticker_id then
			vv.api.schedule_cancel(ticker_id)
			ticker_id = nil
		end
		if statusbar_win and statusbar_win:valid() then
			statusbar_win:close()
			statusbar_win = nil
		end
	end)

	async.wait("never_happening_event")
end)

return M
