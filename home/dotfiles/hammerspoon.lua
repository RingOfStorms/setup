-- Hammerspoon configuration, ~/.hammerspoon/init.lua

-- Things we can't do here:
-- + caps lock to escape, can't map caps lock press since mac wont send that to apps, must be set manually in system proferences
-- + remove all default keyboard shortcuts in system preferences, this cannot be automated as far as I know
--   + set mission control left/right to ctrl + h/l

-- Note we set things into global vars like "GFirefox" so that lua does not GC our event listeners

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

local disabled_keys = {}
local function disableKey(applicationName, keyCode, modifiers)
  disabled_keys[applicationName] = disabled_keys[applicationName] or {}
  if modifiers then
    table.insert(disabled_keys[applicationName], { keyCode, modifiers })
  else
    table.insert(disabled_keys[applicationName], { keyCode })
  end
end

local function click(location, modifiers)
  hs.eventtap.event.newMouseEvent(hs.eventtap.event.types["leftMouseDown"], location, modifiers):post()
  hs.timer.doAfter(0.01, function()
    hs.eventtap.event.newMouseEvent(hs.eventtap.event.types["leftMouseUp"], location, modifiers):post()
  end)
end

local function wrapAdd(n, x, min, max)
  local range = max - min + 1
  local result = (n + x - min) % range + min
  return result
end
-- <<< END helper functions

-- Firefox updates
GFirefox = {
  hs.eventtap
      .new({ hs.eventtap.event.types.leftMouseDown }, function(event)
        local cancel = false
        -- Change ctrl left click to cmd left click
        try(function()
          local app = hs.window.focusedWindow():application()
          if app and app:name() == "Firefox" then
            if event:getFlags()["ctrl"] then
              cancel = true
              click(event:location(), { "cmd" })
            end
          end
        end)
        return cancel
      end)
      :start(),
}

-- Disabled keys
GDisableKeys = {
  hs.eventtap
      .new({ hs.eventtap.event.types.keyDown }, function(event)
        local cancel = false
        try(function()
          local app = hs.window.focusedWindow():application()
          local disabled = disabled_keys[app:name()]
          if disabled then
            for _, key_mod in ipairs(disabled) do
              local keyCode, modifiers = table.unpack(key_mod)
              if event:getKeyCode() == keyCode then
                if modifiers then
                  for _, modifier in ipairs(modifiers) do
                    if not event:getFlags()[modifier] then
                      return
                    end
                  end
                end
                cancel = true
              end
            end
          end
        end)
        return cancel
      end)
      :start(),
}

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

-- Debugging updates
if true then
  GWindowName = {
    hs.eventtap
        .new({ hs.eventtap.event.types.leftMouseUp }, function(event)
          try(function()
            local app = hs.window.focusedWindow():application()
            if app and event:getFlags().cmd then
              hs.alert(app:name())
            end
            -- end)
          end)
        end)
        :start(),
  }
end

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

-- test = hs.eventtap.new({ hs.eventtap.event.types.leftMouseDown }, function ()
--   local win = window.focusedWindow()
--   if win then
--     hs.alert("window clicked")
--   end
-- end):start()

hs.alert("hammerspoon loaded")

-- hs.screen.mainScreen()
--
-- local textEdit = hs.appfinder.appFromName("TextEdit")
-- hs.tabs.enableForApp(textEdit)
