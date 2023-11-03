-- Hammerspoon configuration, ~/.hammerspoon/init.lua + modules

-- Things we can't do here:
-- + caps lock to escape, can't map caps lock press since mac wont send that to apps, must be set manually in system preferences
-- + remove all default keyboard shortcuts in system preferences, this cannot be automated as far as I know
--   + set mission control left/right to ctrl + h/l

local U = require("Util")
local SUPER = "alt"
local HOME = os.getenv("HOME")

-- Hammerspoon reload and disable hotkeys, enable these
-- first so we can abort if something takes over
hs.hotkey.bind({ "ctrl", SUPER }, "r", function()
  hs.reload()
end, nil, nil)

local hsDisabled = U.flagFile(HOME .. "/.hammerspoon/_disabled")
hs.hotkey.bind({ "shift", SUPER }, "Q", function()
  hsDisabled.toggle()
  hs.reload()
end)

if hsDisabled.isOn() then
  hs.alert("Hammerspoon Disabled")
  return
else
  hs.alert("Hammerspoon Loaded")
end

require("AwesomeWM").setup {
  superKey = SUPER,
  windowFrameUpdateInterval = 0,
  guideSettings = { stroke = 3, color = { white = 1 } },
}

-- Firefox updates
U.p(hs.eventtap
  .new({ hs.eventtap.event.types.leftMouseDown }, function(event)
    -- Change ctrl left click to cmd left click
    if hs.window and hs.window.focusedWindow() then
      local app = hs.window.focusedWindow():application()
      if app and app:name() == "Firefox" then
        if event:getFlags()["ctrl"] then
          U.hs.click(event:location(), { "cmd" })
          return true
        end
      end
    end
  end)
  :start())

-- ctrl bindings for more linux like feel on mac
U.hs.mapShortcut({ "f", { "control" } }, { "f", { "command" } })
U.hs.mapShortcut({ "a", { "control" } }, { "a", { "command" } }, { blacklist = { "WezTerm" } })
U.hs.mapShortcut({ "c", { "control" } }, { "c", { "command" } }, { blacklist = { "WezTerm" } })
U.hs.mapShortcut({ "v", { "control" } }, { "v", { "command" } }, { blacklist = { "WezTerm" } })
U.hs.mapShortcut({ "x", { "control" } }, { "x", { "command" } }, { blacklist = { "WezTerm" } })
U.hs.mapShortcut({ "z", { "control" } }, { "z", { "command" } }, { blacklist = { "WezTerm" } })
U.hs.mapShortcut({ "t", { "control" } }, { "t", { "command" } })
U.hs.mapShortcut({ "w", { "control" } }, { "w", { "command" } })
U.hs.mapShortcut({ "t", { "control", "shift" } }, { "t", { "command", "shift" } })
U.hs.mapShortcut({ ".", { "control" } }, { ".", { "command" } }, { whitelist = { "Firefox", "Google Chrome" } })
U.hs.mapShortcut({ "r", { "control" } }, { "r", { "command" } }, { whitelist = { "Firefox", "Google Chrome" } })
U.hs.mapShortcut(
  { "r", { "control", "shift" } },
  { "r", { "command", "shift" } },
  { whitelist = { "Firefox", "Google Chrome" } }
)

-- spotlight shortcut with super key
-- TODO replace this with a better app picker? I Don't like spotlight
--   + in spotlight when typing an app that is already open it just switches to it, I want it to launch a new window of that app
U.hs.mapShortcut({ "Space", { SUPER } }, { "Space", { "command" } })
U.hs.mapShortcut({ "q", { SUPER } }, { "q", { "command" } })

-- Random debug things
-- Create an event tap that listens for all events (needs to stay global or it will stop on its own)
-- U.p(hs.eventtap
--   .new({ hs.eventtap.event.types.keyDown }, function(event)
--     info(
--       "keyDown event: "
--       .. string.format(
--         " Key code: %s, Characters: %s, Modifiers: %s",
--         event:getKeyCode(),
--         event:getCharacters(),
--         flagsToString(event:getFlags())
--       )
--     )
--   end)
--   :start())

-- U.p(hs.application.watcher
--   .new(function(appName, eventType, appObject)
--     info("app event: " .. appName .. " " .. eventType .. " " .. inspect(appObject))
--   end)
--   :start())

-- test = hs.eventtap.new({ hs.eventtap.event.types.leftMouseDown }, function ()
--   local win = window.focusedWindow()
--   if win then
--     hs.alert("window clicked")
--   end
-- end):start()
