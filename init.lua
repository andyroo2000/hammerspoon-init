-- VARIABLES -------------------------------------------------------------------

local alt = {"alt"}
local cmd = {"cmd"}
local ctrl = {"ctrl"}
local mash = {"cmd", "alt", "ctrl"}
local mashshift = {"cmd", "alt", "ctrl", "shift"}




-- FUNCTIONS -------------------------------------------------------------------

-- Send an OSX native notification
function fancyNotify(message)
     hs.notify.new({title="Hammerspoon", informativeText=message}):send():release()
end

-- Determine whether a reload is necessary
function reloadConfig(files)
    doReload = false
    for _,file in pairs(files) do
        if file:sub(-4) == ".lua" then
            doReload = true
        end
    end
    if doReload then
        hs.reload()
    end
end

-- Create cleaner syntax for creating app shortcuts
function appShortcut(modifier, character, application)
    hs.hotkey.bind(modifier, character, function() hs.application.launchOrFocus(application) end)
end

-- Show a circle around the mouse, in case you don't know where it is on the screen
function mouseHighlight()
    -- Delete an existing highlight if it exists
    if mouseCircle then
        mouseCircle:delete()
        if mouseCircleTimer then
            mouseCircleTimer:stop()
        end
    end
    -- Get the current co-ordinates of the mouse pointer
    mousepoint = hs.mouse.get()
    -- Prepare a big red circle around the mouse pointer
    mouseCircle = hs.drawing.circle(hs.geometry.rect(mousepoint.x-40, mousepoint.y-40, 80, 80))
    mouseCircle:setStrokeColor({["red"]=1,["blue"]=0,["green"]=0,["alpha"]=1})
    mouseCircle:setFill(false)
    mouseCircle:setStrokeWidth(5)
    mouseCircle:show()

    -- Set a timer to delete the circle after 3 seconds
    mouseCircleTimer = hs.timer.doAfter(2, function() mouseCircle:delete() end)
end





-- EXECUTE ALL CODE BELOW ------------------------------------------------------

-- Auto reload when config file is modified
hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
fancyNotify("Config Loaded")

-- Disable window movement animations
hs.window.animationDuration = 0

-- Application shortcuts
appShortcut(alt, "C", "Google Chrome")
appShortcut(alt, "P", "System Preferences")
appShortcut(alt, "S", "Sublime Text")
appShortcut(alt, "T", "iTerm")
appShortcut(alt, "I", "IntelliJ IDEA 14")
appShortcut(alt, "S", "Spotify")--


-- Highlight the mouse cursor
hs.hotkey.bind(mash, "m", mouseHighlight)

--------------------------------------------------------------------------------

-- Send app to left half of screen
hs.hotkey.bind(mash, "Left", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
end)

-- Send app to right half of screen
hs.hotkey.bind(mash, "Right", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x + (max.w / 2)
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
end)

-- Make app take up the entire screen
hs.hotkey.bind(mash, "Up", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w
  f.h = max.h
  win:setFrame(f)
end)




--------------------------------------------------------------------------------
-- Manual window moving and resizing
-- Credit to GitHub user: ztomer
 
hs.grid.MARGINX = 0
hs.grid.MARGINY = 0
hs.grid.GRIDHEIGHT = 18
hs.grid.GRIDWIDTH = 18
 
--Alter gridsize
hs.hotkey.bind(mashshift, '=', function() hs.grid.adjustHeight( 1) end)
hs.hotkey.bind(mashshift, '-', function() hs.grid.adjustHeight(-1) end)
hs.hotkey.bind(mash, '=', function() hs.grid.adjustWidth( 1) end)
hs.hotkey.bind(mash, '-', function() hs.grid.adjustWidth(-1) end)
 
--Snap windows
hs.hotkey.bind(mash, ';', function() hs.grid.snap(hs.window.focusedWindow()) end)
hs.hotkey.bind(mash, "'", function() hs.fnutils.map(hs.window.visibleWindows(), hs.grid.snap) end)
 
--Move windows
hs.hotkey.bind(mash, 'j', hs.grid.pushWindowDown)
hs.hotkey.bind(mash, 'k', hs.grid.pushWindowUp)
hs.hotkey.bind(mash, 'h', hs.grid.pushWindowLeft)
hs.hotkey.bind(mash, 'l', hs.grid.pushWindowRight)
 
--resize windows
hs.hotkey.bind(mashshift, 'k', hs.grid.resizeWindowShorter)
hs.hotkey.bind(mashshift, 'j', hs.grid.resizeWindowTaller)
hs.hotkey.bind(mashshift, 'l', hs.grid.resizeWindowWider)
hs.hotkey.bind(mashshift, 'h', hs.grid.resizeWindowThinner)
