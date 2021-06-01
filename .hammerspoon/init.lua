-- local WindowResizer = require("window-resizer")
--
-- hs.hotkey.bind({"cmd", "alt"}, "left", function() WindowResizer.moveWindowLeft() end)
-- hs.hotkey.bind({"cmd", "alt"}, "right", function() WindowResizer.moveWindowRight() end)
-- hs.hotkey.bind({"cmd", "alt"}, "up", function() WindowResizer.moveWindowUp() end)
-- hs.hotkey.bind({"cmd", "alt"}, "down", function() WindowResizer.moveWindowDown() end)
-- hs.hotkey.bind({"cmd", "alt"}, "t", function() WindowResizer.maximizeWindow() end)

function focusApp(applicationName)
  if hs.application.frontmostApplication():name() ~= applicationName then
    hs.application.launchOrFocus(applicationName)
  else
    hs.application.get(applicationName):hide()
  end
end

hs.hotkey.bind({"alt"}, "c", function() focusApp("Google Chrome") end)
hs.hotkey.bind({"alt"}, "x", function() focusApp("Mattermost") end)
hs.hotkey.bind({"alt"}, "m", function() focusApp("Mail") end)
hs.hotkey.bind({"alt"}, "`", function() focusApp("Alacritty") end)
hs.hotkey.bind({"alt"}, "p", function() focusApp("MacPass") end)
hs.hotkey.bind({"alt"}, "f", function() focusApp("Finder") end)
hs.hotkey.bind({"alt"}, "n", function() focusApp("Notes") end)
hs.hotkey.bind({"alt"}, "w", function() focusApp("Google Calendar") end)



