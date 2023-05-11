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

config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"

wezterm.on("format-tab-title", function(tab)
	local pwd = tab.active_pane.current_working_dir
	-- gets basename of path. From https://stackoverflow.com/a/39872872
	return pwd:sub(pwd:find("/[^/|\\]*$") + 1)
end)

return config
