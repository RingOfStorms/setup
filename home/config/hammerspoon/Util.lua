_GLOBAL = {
  _pid = 0,
  _persist = {},
}
local MOD = {}

MOD.info = hs.logger.new("INFO", "info").i
MOD.inspect = hs.inspect.inspect

MOD.try = function(func)
  local status, error = pcall(func)
  if not status then
    MOD.info("Failed to run function: " .. tostring(error))
  end
end

MOD.persist = function(...)
  _GLOBAL._pid = _GLOBAL._pid + 1
  local id = _GLOBAL._pid
  _GLOBAL._persist[id] = { ... }
  return function()
    _GLOBAL._persist[id] = nil
  end, id
end
-- shorthand
MOD.p = MOD.persist

MOD.flagFile = function(file_path)
  return {
    toggle = function()
      local f = io.open(file_path, "r")
      local FLAG_ON = not not f
      if f then
        f:close()
      end
      if FLAG_ON then
        os.remove(file_path)
      else
        local create = io.open(file_path, "w")
        if create then
          create:close()
        end
      end
      return not FLAG_ON
    end,
    isOn = function()
      local f = io.open(file_path, "r")
      local FLAG_ON = not not f
      if f then
        f:close()
      end
      return FLAG_ON
    end,
  }
end

MOD.table = {
  contains = function(table, item)
    if table then
      for _, value in ipairs(table) do
        if value == item then
          return true
        end
      end
    end
    return false
  end,
}

MOD.hs = {
  click = function(location, modifiers, returnToOriginalLocation)
    local currentPos = hs.mouse.getAbsolutePosition()
    hs.eventtap.event.newMouseEvent(hs.eventtap.event.types["leftMouseDown"], location, modifiers):post()
    hs.timer.doAfter(0.005, function()
      hs.eventtap.event.newMouseEvent(hs.eventtap.event.types["leftMouseUp"], location, modifiers):post()
      if returnToOriginalLocation then
        hs.mouse.setAbsolutePosition(currentPos)
      end
    end)
  end,
  mapShortcut = function(to, from, opts)
    local function callFrom()
      -- hs.alert("calling shortcut " .. MOD.inspect(from))
      if from[2] then
        -- Need to clear the currently held modifier first or it doesn't work 100% of the time
        hs.eventtap.event.newKeyEvent(nil, from[1], false):post()
      end
      hs.eventtap.keyStroke(from[2], from[1], 0)
    end
    local hotkey = hs.hotkey.bind(to[2], to[1], callFrom, nil, callFrom)
    local events = {}
    if opts and opts.whitelist then
      hotkey:disable()
      events.whitelist = hs.application.watcher
          .new(function(appName, eventType, appObject)
            -- hs.alert("test " .. appName)
            local isWhitelisted = MOD.table.contains(opts.whitelist, appName)
            if isWhitelisted and eventType == hs.application.watcher.activated then
              hs.timer.doAfter(0.1, function()
                hotkey:enable()
              end)
            elseif isWhitelisted and eventType == hs.application.watcher.deactivated then
              hotkey:disable()
            end
          end)
          :start()
    elseif opts and opts.blacklist then
      events.blacklist = hs.application.watcher
          .new(function(appName, eventType, appObject)
            local isBlacklisted = MOD.table.contains(opts.blacklist, appName)
            if isBlacklisted and eventType == hs.application.watcher.activated then
              -- hs.alert("Disabled hotkey " .. MOD.inspect(to))
              hs.timer.doAfter(0.1, function()
                hotkey:disable()
              end)
            elseif isBlacklisted and eventType == hs.application.watcher.deactivated then
              hotkey:enable()
            end
          end)
          :start()
    end
    MOD.p(events)
    return events, hotkey
  end,
  flagsToString = function(flags)
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
  end,
}

_GLOBAL.UTILS = MOD
return MOD, _GLOBAL

-- local disabled_keys = {}
-- local function disableKey(applicationName, keyCode, modifiers)
--   disabled_keys[applicationName] = disabled_keys[applicationName] or {}
--   if modifiers then
--     table.insert(disabled_keys[applicationName], { keyCode, modifiers })
--   else
--     table.insert(disabled_keys[applicationName], { keyCode })
--   end
-- end

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
--
--

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
