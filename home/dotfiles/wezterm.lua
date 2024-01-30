local info = os.getenv("WEZTERM_EXECUTABLE")
local isMac = info:find("MacOS") ~= nil

-- gets basename of path. From https://stackoverflow.com/a/39872872
-- local function basename(str)
--   return str:sub(str:find("/[^/|\\]*$") + 1)
-- end

local wezterm = require("wezterm")
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- config.disable_default_key_bindings = true
-- config.keys = {
-- {
--   key = "w",
--   mods = "CTRL",
--   action = wezterm.action.CloseCurrentTab({ confirm = true }),
-- },
-- {
--   key = "t",
--   mods = "CTRL",
--   action = wezterm.action.SpawnTab("CurrentPaneDomain"),
-- },
-- {
--   key = "1",
--   mods = "CTRL",
--   action = wezterm.action.ActivateTab(0),
-- },
-- {
--   key = "2",
--   mods = "CTRL",
--   action = wezterm.action.ActivateTab(1),
-- },
-- {
--   key = "3",
--   mods = "CTRL",
--   action = wezterm.action.ActivateTab(2),
-- },
-- {
--   key = "4",
--   mods = "CTRL",
--   action = wezterm.action.ActivateTab(3),
-- },
-- {
--   key = "5",
--   mods = "CTRL",
--   action = wezterm.action.ActivateTab(4),
-- },
-- {
--   key = "6",
--   mods = "CTRL",
--   action = wezterm.action.ActivateTab(5),
-- },
-- {
--   key = "7",
--   mods = "CTRL",
--   action = wezterm.action.ActivateTab(6),
-- },
-- {
--   key = "8",
--   mods = "CTRL",
--   action = wezterm.action.ActivateTab(7),
-- },
-- {
--   key = "9",
--   mods = "CTRL",
--   action = wezterm.action.ActivateTab(8),
-- },
-- {
--   key = "0",
--   mods = "CTRL",
--   action = wezterm.action.ActivateTab(9),
-- },
-- }

-- config.color_scheme = "Material Darker (base16)"

-- My modifications: https://gist.github.com/RingOfStorms/b2ff0c4e37f5be9f985c72c3ec9a3e62
local scheme = wezterm.get_builtin_color_schemes()["Catppuccin Mocha"]
local c = {
  text = "#e0e0e0",
  subtext1 = "#cccccc",
  subtext0 = "#b8b8b8",
  overlay2 = "#a3a3a3",
  overlay1 = "#8c8c8c",
  overlay0 = "#787878",
  surface2 = "#636363",
  surface1 = "#4f4f4f",
  surface0 = "#3b3b3b",
  base = "#262626",
  mantle = "#1f1f1f",
  crust = "#171717",
}
scheme.foreground = c.text
scheme.background = c.base
scheme.cursor_fg = c.crust
scheme.selection_fg = c.text
scheme.selection_bg = c.surface2
scheme.scrollbar_thumb = c.surface2
scheme.split = c.overlay0
scheme.ansi[1] = c.surface1
scheme.ansi[8] = c.subtext1
scheme.brights[1] = c.surface2
scheme.brights[8] = c.subtext0
scheme.visual_bell = c.surface0
-- I don't use tab bar so not really needed
scheme.tab_bar.background = c.crust
scheme.tab_bar.active_tab.fg_color = c.crust
scheme.tab_bar.inactive_tab.bg_color = c.mantle
scheme.tab_bar.inactive_tab.fg_color = c.text
scheme.tab_bar.inactive_tab_hover.bg_color = c.base
scheme.tab_bar.inactive_tab_hover.fg_color = c.text
scheme.tab_bar.new_tab.bg_color = c.surface0
scheme.tab_bar.new_tab.fg_color = c.text
scheme.tab_bar.new_tab_hover.bg_color = c.surface1
scheme.tab_bar.new_tab_hover.fg_color = c.text
scheme.tab_bar.inactive_tab_edge = c.surface0

config.color_schemes = { ["Catppuccin Coal"] = scheme }
config.color_scheme = "Catppuccin Coal"

-- return {
--   color_schemes = {
--     -- Override the builtin Gruvbox Light scheme with our modification.
--     ['Gruvbox Light'] = scheme,

--     -- We can also give it a different name if we don't want to override
--     -- the default
--     ['Gruvbox Red'] = scheme,
--   },
--   color_scheme = 'Gruvbox Light',
-- }

if isMac then
  config.font_size = 16
  config.window_decorations = "RESIZE"
end

config.window_frame = {
  font = wezterm.font({ family = "JetBrains Mono", weight = "Bold" }),
}

config.enable_tab_bar = false
-- config.colors = {
--   tab_bar = {
--     active_tab = {
--       bg_color = "#1c1c1c",
--       fg_color = "#ababab",
--     },
--   },
-- }

config.font = wezterm.font_with_fallback({
  {
    family = "JetBrainsMono Nerd Font Mono",
    weight = "Regular",
  },
  { family = "Terminus" },
})

-- wezterm.on("format-tab-title", function(tab)
--   local p = tab.active_pane
--   local idx = tab.is_active and "" or tab.tab_index + 1
--   local dir = basename(p.current_working_dir)

--   local title = idx .. " " .. dir

--   local proc = basename(p.foreground_process_name)
--   if proc ~= "zsh" then
--     title = title .. " " .. proc
--   end

--   return title
-- end)

return config
