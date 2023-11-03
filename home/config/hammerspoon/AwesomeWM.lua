local function getQuadrant(window, position)
  local origin = { x = window.x + window.w / 2, y = window.y + window.h / 2 }

  if position.x < origin.x then
    if position.y < origin.y then
      return 1, { x = window.x, y = window.y }, origin
    else
      return 4, { x = window.x, y = window.y + window.h }, origin
    end
  else
    if position.y < origin.y then
      return 2, { x = window.x + window.w, y = window.y }, origin
    else
      return 3, { x = window.x + window.w, y = window.y + window.h }, origin
    end
  end
end

local function getFirstWindowAtPosition(position)
  local windows = hs.window.orderedWindows()
  local clickedWindow = nil
  for i, window in ipairs(windows) do
    if hs.geometry.isPointInRect(position, window:frame()) then
      clickedWindow = window
      break
    end
  end
  return clickedWindow
end

local function growFrame(f, grow)
  return {
    x = f.x - grow,
    y = f.y - grow,
    w = f.w + grow * 2,
    h = f.h + grow * 2,
  }
end

local defaultOptions = {
  superKey = "alt",
  windowFrameUpdateInterval = 0.02,
  guideSettings = { stroke = 3, strokeDashPattern = {}, color = { white = 1 } },
}

local enable = function(options)
  local state = {
    options = defaultOptions,
    selectedWindow = nil,
    -- mode, 0 = positioner, 1-4 is resizer direction
    resizeQuadrant = 0,
    clickPos = nil,
    originalFrame = nil,
    frame = nil,
    updateGuide = nil,
    updateWindow = nil,
    --
    guide = nil,
    events = nil,
  }

  state.options.superKey = options.superKey or defaultOptions.superKey
  state.options.windowFrameUpdateInterval = options.windowFrameUpdateInterval
    or defaultOptions.windowFrameUpdateInterval
  state.options.guideSettings.stroke = options.guideSettings.stroke or defaultOptions.guideSettings.stroke
  state.options.guideSettings.color = options.guideSettings.color or defaultOptions.guideSettings.color

  state.updateFrame = function()
    local w = state.selectedWindow
    if w then
      local m = hs.mouse.absolutePosition()
      -- local w = GSuperPos.origin.x - 0
      local mouseDelta = { x = m.x - state.clickPos.x, y = m.y - state.clickPos.y }
      local r = state.resizeQuadrant
      if r == 0 then
        state.frame = {
          x = state.originalFrame.x + mouseDelta.x,
          y = state.originalFrame.y + mouseDelta.y,
          w = state.originalFrame.w,
          h = state.originalFrame.h,
        }
      else
        local topLeft = {
          x = state.originalFrame.x + ((r == 1 or r == 4) and mouseDelta.x or 0),
          y = state.originalFrame.y + ((r == 1 or r == 2) and mouseDelta.y or 0),
        }
        local bottomRight = {
          x = state.originalFrame.x + state.originalFrame.w + ((r == 3 or r == 2) and mouseDelta.x or 0),
          y = state.originalFrame.y + state.originalFrame.h + ((r == 3 or r == 4) and mouseDelta.y or 0),
        }
        state.frame = {
          x = topLeft.x,
          y = topLeft.y,
          w = bottomRight.x - topLeft.x,
          h = bottomRight.y - topLeft.y,
        }
      end
      local guideFrame = growFrame(state.frame, state.options.guideSettings.stroke)
      state.guide:topLeft(guideFrame)
      state.guide:size(guideFrame)
    else
      if state.guide then
        state.guide:hide()
      end
      state.updateGuide:stop()
    end
  end

  state.grabWindow = function(event)
    if state.selectedWindow then
      -- disable the opposite click
      return true
    end

    local isSuper = event:getFlags()[state.options.superKey]
    local cancel = isSuper
    local windowAtClick = getFirstWindowAtPosition(event:location())
    if windowAtClick then
      local app = windowAtClick:application()
      if app and isSuper then
        -- initial positions
        local m = event:location()
        local f = windowAtClick:frame()

        state.clickPos = m
        state.originalFrame = f
        -- choose mode
        if event:getType() == 3 then
          local quadrant, cornerPos, origin = getQuadrant(f, m)
          state.resizeQuadrant = quadrant
          state.corner = cornerPos
          state.origin = origin
          -- snap mouse to corner, this is important since we'll use this from the origin for resizing calculation
          -- hs.mouse.absolutePosition(cornerPos)
        end
        -- Focus the window if not focused
        if hs.window.focusedWindow() ~= windowAtClick then
          windowAtClick:focus()
        end
        -- Start the updaters
        state.selectedWindow = windowAtClick
        state.updateGuide:start()
        if state.options.windowFrameUpdateInterval > 0 then
          state.updateWindow:start()
        end
        -- hs.alert(app:name() .. " " .. state.resizeQuadrant)
      end
    end
    return cancel
  end

  state.updateGuide = hs.timer
    .doEvery(0.01, function()
      state.updateFrame()
      local w = state.selectedWindow
      if w then
        if not state.guide:isShowing() then
          state.guide:show()
        end

        state.guide:topLeft(state.frame)
        state.guide:size(state.frame)
      else
        state.guide:hide()
        state.updateGuide:stop()
      end
    end)
    :stop()
  state.updateWindow = hs.timer
    .doEvery(state.options.windowFrameUpdateInterval, function()
      local w = state.selectedWindow
      if w then
        w:setFrame(state.frame)
      else
        state.updateWindow:stop()
      end
    end)
    :stop()

  state.releaseWindow = function()
    if state.selectedWindow then
      state.updateGuide:fire()
      if state.options.windowFrameUpdateInterval == 0 then
        state.updateWindow:start()
      end
      state.updateWindow:fire()
      state.selectedWindow = nil
      state.resizeQuadrant = 0
    end
  end

  state.guide = hs.canvas.new({ x = 0, y = 0, w = 0, h = 0 })
  state.guide[1] = {
    type = "rectangle",
    action = "stroke",
    strokeColor = state.options.guideSettings.color,
    strokeWidth = state.options.guideSettings.stroke,
  }
  state.events = {
    hs.eventtap.new({ hs.eventtap.event.types.leftMouseDown }, state.grabWindow):start(),
    hs.eventtap.new({ hs.eventtap.event.types.rightMouseDown }, state.grabWindow):start(),
    hs.eventtap.new({ hs.eventtap.event.types.leftMouseUp }, state.releaseWindow):start(),
    hs.eventtap.new({ hs.eventtap.event.types.rightMouseUp }, state.releaseWindow):start(),
  }

  return state
end

return enable
