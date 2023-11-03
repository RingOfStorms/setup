-- Hammerspoon configuration, ~/.hammerspoon/init.lua + modules

-- Things we can't do here:
-- + caps lock to escape, can't map caps lock press since mac wont send that to apps, must be set manually in system preferences
-- + remove all default keyboard shortcuts in system preferences, this cannot be automated as far as I know
--   + set mission control left/right to ctrl + h/l

local LOG_KEYS = false

local SUPER = "alt"

-- >>> Helper functions
local info = hs.logger.new("INFO", "info").i
local inspect = hs.inspect.inspect
local try = function(func)
  local status, error = pcall(func)
  if not status then
    info("Failed to run function: " .. tostring(error))
  end
end

-- local disabled_keys = {}
-- local function disableKey(applicationName, keyCode, modifiers)
--   disabled_keys[applicationName] = disabled_keys[applicationName] or {}
--   if modifiers then
--     table.insert(disabled_keys[applicationName], { keyCode, modifiers })
--   else
--     table.insert(disabled_keys[applicationName], { keyCode })
--   end
-- end

local function click(location, modifiers)
  hs.eventtap.event.newMouseEvent(hs.eventtap.event.types["leftMouseDown"], location, modifiers):post()
  hs.timer.doAfter(0.01, function()
    hs.eventtap.event.newMouseEvent(hs.eventtap.event.types["leftMouseUp"], location, modifiers):post()
  end)
end

-- local function wrapAdd(n, x, min, max)
--   local range = max - min + 1
--   local result = (n + x - min) % range + min
--   return result
-- end

-- local function rateLimit(func, timeUnit)
--   local canCall = true
--   local waiting = false
--   local args = nil

--   return function(...)
--     args = table.pack(...)
--     if canCall then
--       func(...)
--       canCall = false
--       hs.timer.doAfter(timeUnit, function()
--         canCall = true
--         if waiting then
--           func(table.unpack(args))
--           waiting = false
--           args = nil
--         end
--       end)
--     else
--       if not waiting then
--         waiting = true
--       end
--     end
--   end
-- end

-- <<< END helper functions

require("AwesomeWM")({
  superKey = SUPER,
  windowFrameUpdateInterval = 0,
  guideSettings = { stroke = 3, color = { white = 1 } },
})

-- Firefox updates
GFirefox = {
  hs.eventtap
    .new({ hs.eventtap.event.types.leftMouseDown }, function(event)
      -- Change ctrl left click to cmd left click
      if hs.window and hs.window.focusedWindow() then
        local app = hs.window.focusedWindow():application()
        if app and app:name() == "Firefox" then
          if event:getFlags()["ctrl"] then
            click(event:location(), { "cmd" })
            return true
          end
        end
      end
    end)
    :start(),
}

-- Disabled keys
-- GDisableKeys = {
--   hs.eventtap
--     .new({ hs.eventtap.event.types.keyDown }, function(event)
--       local cancel = false
--       local app = hs.window.focusedWindow():application()
--       local disabled = disabled_keys[app:name()]
--       if disabled then
--         for _, key_mod in ipairs(disabled) do
--           local keyCode, modifiers = table.unpack(key_mod)
--           if event:getKeyCode() == keyCode then
--             if modifiers then
--               for _, modifier in ipairs(modifiers) do
--                 if not event:getFlags()[modifier] then
--                   return
--                 end
--               end
--             end
--             cancel = true
--           end
--         end
--       end
--       return cancel
--     end)
--     :start(),
-- }

local function mapShortcut(to, from)
  local function callFrom()
    if from[2] then
      -- Need to clear the currently held modifier first or it doesn't work 100% of the time
      hs.eventtap.event.newKeyEvent(nil, from[1], false):post()
    end
    hs.eventtap.keyStroke(from[2], from[1], 0)
  end
  hs.hotkey.bind(to[2], to[1], callFrom, nil, callFrom)
end

-- cmd + {} -> ctrl {} remaps
mapShortcut({ "f", { "control" } }, { "f", { "command" } })
mapShortcut({ "a", { "control" } }, { "a", { "command" } })
mapShortcut({ "c", { "control" } }, { "c", { "command" } })
mapShortcut({ "v", { "control" } }, { "v", { "command" } })
mapShortcut({ "x", { "control" } }, { "x", { "command" } })
mapShortcut({ "z", { "control" } }, { "z", { "command" } })

-- spotlight
mapShortcut({ "Space", { SUPER } }, { "Space", { "command" } })
mapShortcut({ "q", { SUPER } }, { "q", { "command" } })

local function flagsToString(flags)
  local str = ""
  if flags["cmd"] then
    str = str .. "⌘"
  end
  if flags["alt"] then
    str = str .. "⌥"
  end
  if flags["ctrl"] then
    str = str .. "⌃"
  end
  if flags["shift"] then
    str = str .. "⇧"
  end
  if flags["fn"] then
    str = str .. "fn"
  end
  return str
end

-- Create an event tap that listens for all events (needs to stay global or it will stop on its own)
if LOG_KEYS then
  GKeyLogger = hs.eventtap
    .new({ hs.eventtap.event.types.keyDown }, function(event)
      info(
        "keyDown event: "
          .. string.format(
            " Key code: %s, Characters: %s, Modifiers: %s",
            event:getKeyCode(),
            event:getCharacters(),
            flagsToString(event:getFlags())
          )
      )
    end)
    :start()
end

-- test = hs.eventtap.new({ hs.eventtap.event.types.leftMouseDown }, function ()
--   local win = window.focusedWindow()
--   if win then
--     hs.alert("window clicked")
--   end
-- end):start()

hs.hotkey.bind({ "ctrl", SUPER }, "r", function()
  hs.reload()
end, nil, nil)
hs.alert("Hammerspoon Loaded")
