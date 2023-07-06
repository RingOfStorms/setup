-- https://stackoverflow.com/a/30960054
function getOS()
  local binary_format = package.cpath:match("%p[\\|/]?%p(%a+)")
  if binary_format == "dll" then
    return "Windows"
  elseif binary_format == "so" then
    return "Linux"
  elseif binary_format == "dylib" then
    return "MacOS"
  end
end

-- gets basename of path. From https://stackoverflow.com/a/39872872
function basename(str)
  return str:sub(str:find("/[^/|\\]*$") + 1)
end

local wezterm = require("wezterm")
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

if getOS() ~= "MacOS" then
  config.disable_default_key_bindings = true
  config.keys = {
    {
      key = "w",
      mods = "ALT",
      action = wezterm.action.CloseCurrentTab({ confirm = true }),
    },
    {
      key = "t",
      mods = "ALT",
      action = wezterm.action.SpawnTab("CurrentPaneDomain"),
    },
    {
      key = "1",
      mods = "ALT",
      action = wezterm.action.ActivateTab(0),
    },
    {
      key = "2",
      mods = "ALT",
      action = wezterm.action.ActivateTab(1),
    },
    {
      key = "3",
      mods = "ALT",
      action = wezterm.action.ActivateTab(2),
    },
    {
      key = "4",
      mods = "ALT",
      action = wezterm.action.ActivateTab(3),
    },
    {
      key = "5",
      mods = "ALT",
      action = wezterm.action.ActivateTab(4),
    },
    {
      key = "6",
      mods = "ALT",
      action = wezterm.action.ActivateTab(5),
    },
    {
      key = "7",
      mods = "ALT",
      action = wezterm.action.ActivateTab(6),
    },
    {
      key = "8",
      mods = "ALT",
      action = wezterm.action.ActivateTab(7),
    },
    {
      key = "9",
      mods = "ALT",
      action = wezterm.action.ActivateTab(8),
    },
    {
      key = "0",
      mods = "ALT",
      action = wezterm.action.ActivateTab(9),
    },
  }
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

config.font = wezterm.font_with_fallback({ {
  family = "JetBrains Mono",
  weight = "Regular",
}, "Terminus" })

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
