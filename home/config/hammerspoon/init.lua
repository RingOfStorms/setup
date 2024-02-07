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

require("AwesomeWM").setup({
  superKey = SUPER,
  windowFrameUpdateInterval = 0,
  guideSettings = { stroke = 3, color = { white = 1 } },
})

-- Firefox updates
U.p(hs.eventtap
  .new({ hs.eventtap.event.types.leftMouseDown }, function(event)
    -- Change ctrl left click to cmd left click
    if hs.window and hs.window.focusedWindow() then
      local app = hs.window.focusedWindow():application()
      if app and (app:name() == "Firefox" or app:name() == "Vivaldi") then
        if event:getFlags()["ctrl"] then
          U.hs.click(event:location(), { "cmd" })
          return true
        end
      end
    end
  end)
  :start())

-- ctrl bindings for more linux like feel on mac
U.hs.mapShortcut({ "f", { "control" } }, { "f", { "command" } }, { blacklist = { "WezTerm" } })
U.hs.mapShortcut({ "a", { "control" } }, { "a", { "command" } }, { blacklist = { "WezTerm" } })
U.hs.mapShortcut({ "c", { "control" } }, { "c", { "command" } }, { blacklist = { "WezTerm" } })
U.hs.mapShortcut({ "v", { "control" } }, { "v", { "command" } }, { blacklist = { "WezTerm" } })
U.hs.mapShortcut({ "x", { "control" } }, { "x", { "command" } }, { blacklist = { "WezTerm" } })
U.hs.mapShortcut({ "z", { "control" } }, { "z", { "command" } }, { blacklist = { "WezTerm" } })
U.hs.mapShortcut({ "t", { "control" } }, { "t", { "command" } }, { blacklist = { "WezTerm" } })
U.hs.mapShortcut({ "w", { "control" } }, { "w", { "command" } }, { blacklist = { "WezTerm" } })
U.hs.mapShortcut({ "t", { "control", "shift" } }, { "t", { "command", "shift" } }, { blacklist = { "WezTerm" } })
U.hs.mapShortcut({ ".", { "control" } }, { ".", { "command" } }, { whitelist = { "Firefox", "Google Chrome", "Arc" } })
U.hs.mapShortcut(
  { "r", { "control" } },
  { "r", { "command" } },
  { whitelist = { "Firefox", "Google Chrome", "Arc", "Vivaldi" } }
)
U.hs.mapShortcut(
  { "=", { "control" } },
  { "=", { "command" } },
  { whitelist = { "Firefox", "Google Chrome", "Arc", "Vivaldi" } }
)
U.hs.mapShortcut(
  { "-", { "control" } },
  { "-", { "command" } },
  { whitelist = { "Firefox", "Google Chrome", "Arc", "Vivaldi" } }
)
-- for i = 1, 9 do
--   U.hs.mapShortcut(
--     { tostring(i), { "control" } },
--     { tostring(i), { "command" } },
--     { whitelist = { "Firefox", "Google Chrome", "Arc", "Vivaldi" } }
--   )
-- end

U.hs.mapShortcut(
  { "r", { "control", "shift" } },
  { "r", { "command", "shift" } },
  { whitelist = { "Firefox", "Google Chrome", "Arc", "Vivaldi" } }
)

-- Vivaldi 1password hotkey just does not work for me... so we'll click the button instead with hammerspoon
local vivaldi_1password_hotkey = hs.hotkey.bind({ "ctrl" }, ".", function()
  -- Check if Vivaldi is the active application
  local app = hs.application.frontmostApplication()
  if app:name() == "Vivaldi" then
    -- Get the frame of the frontmost window
    local win = app:focusedWindow()
    local frame = win:frame()

    -- Location of the 1Password icon on my machine
    local iconX = frame.x + frame.w - 119 -- X coordinate from the right edge of the window
    local iconY = frame.y + 54            -- Y coordinate from the top edge of the window
    U.hs.click(hs.geometry.point(iconX, iconY), {}, true)

    -- DEBUG
    -- local circle = hs.drawing.circle(hs.geometry.rect(iconX - 7.5, iconY - 7.5, 15, 15))
    -- circle:setFillColor({ ["red"] = 1, ["alpha"] = 1 })
    -- circle:setStroke(false)
    -- circle:show()
    -- hs.timer.doAfter(2, function()
    --   circle:delete()
    -- end)
  else
    -- hs.alert.show("Vivaldi is not focused")
    -- -- Send the Ctrl + . keystroke to the system
    hs.eventtap.keyStroke({ "ctrl" }, ".", 0)
  end
end)
vivaldi_1password_hotkey:disable()
U.p(hs.application.watcher
  .new(function(appName, eventType, appObject)
    -- hs.alert("test " .. appName)
    if appName == "Vivaldi" and eventType == hs.application.watcher.activated then
      hs.timer.doAfter(0.1, function()
        vivaldi_1password_hotkey:enable()
      end)
    elseif appName == "Vivaldi" and eventType == hs.application.watcher.deactivated then
      vivaldi_1password_hotkey:disable()
    end
  end)
  :start())

-- spotlight shortcut with super key
-- TODO replace this with a better app picker? I Don't like spotlight
--   + in spotlight when typing an app that is already open it just switches to it, I want it to launch a new window of that app
U.hs.mapShortcut({ "Space", { SUPER } }, { "Space", { "command" } })
U.hs.mapShortcut({ "q", { SUPER } }, { "q", { "command" } })

-- Random debug things
-- Create an event tap that listens for all events (needs to stay global or it will stop on its own)
-- U.p(hs.eventtap
--   .new({ hs.eventtap.event.types.keyDown }, function(event)
--     U.info(
--       "keyDown event: "
--       .. string.format(
--         " Key code: %s, Characters: %s, Modifiers: %s",
--         event:getKeyCode(),
--         event:getCharacters(),
--         U.hs.flagsToString(event:getFlags())
--       )
--     )
--   end)
--   :start())

-- U.p(hs.application.watcher
--   .new(function(appName, eventType, appObject)
--     U.info("app event: " .. appName .. " " .. eventType .. " " .. U.inspect(appObject))
--   end)
--   :start())

-- test = hs.eventtap.new({ hs.eventtap.event.types.leftMouseDown }, function ()
--   local win = window.focusedWindow()
--   if win then
--     hs.alert("window clicked")
--   end
-- end):start()
