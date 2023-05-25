-- gets basename of path. From https://stackoverflow.com/a/39872872
function basename(str)
	return str:sub(str:find("/[^/|\\]*$") + 1)
end

local wezterm = require("wezterm")
local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.color_scheme = "Material Darker (base16)"

config.window_frame = {
	font = wezterm.font({ family = "JetBrains Mono", weight = "Bold" }),
}

config.colors = {
	tab_bar = {
		active_tab = {
			bg_color = "#1c1c1c",
			fg_color = "#ababab",
		},
	},
}

config.font = wezterm.font({
	family = "JetBrains Mono",
	weight = "Regular",
})

-- config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"

wezterm.on("format-tab-title", function(tab)
	local p = tab.active_pane
	local idx = tab.is_active and '' or tab.tab_index + 1 
	local dir = basename(p.current_working_dir)
	
	local title = idx .. ' ' .. dir

	local proc = basename(p.foreground_process_name)
	if proc ~= 'zsh' then
		title = title .. ' ' .. proc
	end

	return title
end)

return config
