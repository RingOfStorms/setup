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
config.color_scheme = "Catppuccin Mocha"

if isMac then
  config.font_size = 16
  config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
end

config.window_frame = {
  font = wezterm.font({ family = "JetBrains Mono", weight = "Bold" }),
}

config.enable_tab_bar = false;
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
