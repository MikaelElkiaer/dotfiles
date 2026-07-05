local M = {}

local window = require("velvet.window")
local async = require("velvet.async")

-- A table of popups keyed by unique working directory paths:
-- popups[cwd] = { parent_host = parent_host, popup_win = popup_win, visible = boolean, prev_focus = prev_focus }
local popups = {}

local function calculate_geometry()
	local screen = vv.api.get_screen_geometry()
	local width = math.floor(screen.width * 0.85)
	local height = math.floor(screen.height * 0.85)
	if width < 20 then
		width = screen.width
	end
	if height < 10 then
		height = screen.height
	end

	local left = math.floor((screen.width - width) / 2) + 1
	local top = math.floor((screen.height - height) / 2) + 1
	return {
		left = left,
		top = top,
		width = width,
		height = height,
	}
end

local function resize_all_popups()
	local geom = calculate_geometry()
	for _, entry in pairs(popups) do
		if entry.popup_win and entry.popup_win:valid() then
			entry.popup_win:set_geometry(geom)
		end
		if entry.parent_host and entry.parent_host:valid() then
			entry.parent_host:set_geometry(geom)
		end
	end
end

local function close_all_popups()
	for _, entry in pairs(popups) do
		entry.visible = false
		if entry.popup_win and entry.popup_win:valid() then
			entry.popup_win:close()
		end
		if entry.parent_host and entry.parent_host:valid() then
			entry.parent_host:close()
		end
	end
	popups = {}
end

local function hide_all_except(active_cwd)
	for cwd, entry in pairs(popups) do
		if cwd ~= active_cwd and entry.visible then
			entry.visible = false
			if entry.popup_win and entry.popup_win:valid() then
				entry.popup_win:set_visibility(false)
			end
			if entry.parent_host and entry.parent_host:valid() then
				entry.parent_host:set_visibility(false)
			end
		end
	end
end

local function hide_popup(cwd)
	local entry = popups[cwd]
	if not entry then
		return
	end

	entry.visible = false
	if entry.popup_win and entry.popup_win:valid() then
		entry.popup_win:set_visibility(false)
	end
	if entry.parent_host and entry.parent_host:valid() then
		entry.parent_host:set_visibility(false)
	end
	if entry.prev_focus and vv.api.window_is_valid(entry.prev_focus) then
		vv.api.set_focused_window(entry.prev_focus)
		entry.prev_focus = nil
	end
end

local function show_popup(cwd)
	-- Hide any other visible popups first
	hide_all_except(cwd)

	local entry = popups[cwd]
	if not entry then
		return
	end

	local focused = vv.api.get_focused_window()
	-- If we're focusing something that is not our own popup, save it to restore focus later
	if focused ~= 0 and focused ~= entry.popup_win.id then
		entry.prev_focus = focused
	end

	if entry.parent_host and entry.parent_host:valid() then
		entry.parent_host:set_visibility(true)
	end
	if entry.popup_win and entry.popup_win:valid() then
		entry.popup_win:set_visibility(true)
		entry.popup_win:focus()
	end
	entry.visible = true
end

local function create_popup(cwd)
	-- Hide other popups first to avoid overlay/clutter
	hide_all_except(cwd)

	local parent_host = window.create()
	parent_host:set_background_color("black")
	parent_host:set_alpha(0.1)

	-- Create process window for lazygit as child of parent_host so DWM ignores it
	local popup_win = parent_host:create_child_process_window({ "lazygit" }, { working_directory = cwd })
	if not popup_win then
		parent_host:close()
		error("Failed to spawn lazygit popup for " .. cwd)
	end

	-- Styling the popup
	popup_win:set_frame_enabled(true)
	popup_win:set_frame_color("magenta")
	popup_win:set_title("Lazygit Popup: " .. cwd)
	popup_win:set_z_index(vv.z_hint.popup)
	parent_host:set_z_index(vv.z_hint.popup - 1)

	local geom = calculate_geometry()
	popup_win:set_geometry(geom)
	parent_host:set_geometry(geom)

	local focused = vv.api.get_focused_window()
	local prev_focus = (focused ~= 0) and focused or nil

	popups[cwd] = {
		parent_host = parent_host,
		popup_win = popup_win,
		visible = true,
		prev_focus = prev_focus,
	}

	-- Focus the newly created popup
	popup_win:focus()

	-- Clean up if lazygit process exits
	popup_win:on_window_closed(function()
		if popups[cwd] then
			if popups[cwd].parent_host and popups[cwd].parent_host:valid() then
				popups[cwd].parent_host:close()
			end
			popups[cwd] = nil
		end
	end)

	-- Move the host to follow the popup
	popup_win:on_window_moved(function(_, args)
		local entry = popups[cwd]
		if entry and entry.parent_host and entry.parent_host:valid() then
			entry.parent_host:set_geometry(args.new_size)
		end
	end)

	-- Handle screen resize
	popup_win:on_screen_resized(function()
		resize_all_popups()
	end)
end

function M.toggle()
	local cwd = nil
	local fg = vv.api.get_focused_window()
	if fg ~= 0 then
		cwd = vv.api.window_get_working_directory(fg)
	end
	if not cwd or cwd == "" then
		cwd = vv.api.get_startup_directory() or "/"
	end

	local entry = popups[cwd]
	if not entry or not entry.popup_win or not entry.popup_win:valid() then
		create_popup(cwd)
	elseif entry.visible then
		hide_popup(cwd)
	else
		show_popup(cwd)
	end
end

-- Use async coroutine to safely register a cleanup on config reload
async.run(function()
	async.defer(function()
		close_all_popups()
	end)

	-- Wait forever for an event that never happens
	async.wait("never_happening_event")
end)

return M
