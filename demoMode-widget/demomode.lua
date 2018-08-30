-------------------------------------------------
-- DemoMode button for Awesome Window Manager
-- Turns off notifications and send a heartbeat to xscreensaver

-- @author Raphaël Fournier-S'niehotta
-- @copyright 2018 Raphaël Fournier-S'niehotta
-------------------------------------------------

local wibox = require("wibox")
local watch = require("awful.widget.watch")
local awful = require("awful")
local beautiful = require("beautiful")
local naughty       = require("naughty")
local gears = require("gears")

local XSCREENSAVER_DEACTIVATE_COMMAND = "xscreensaver-command -deactivate"
local XSCREENSAVER_TIMER = 61
local iconpath = "/home/raph/.config/awesome/themes/myzenburn/demomode.png"

local demoMode_widget = wibox.widget {
  wibox.widget {
      image  = beautiful.demomode_icon or iconpath,
      resize = true,
      widget = wibox.widget.imagebox
    },
    widget = wibox.container.background
    }

watch(XSCREENSAVER_DEACTIVATE_COMMAND, XSCREENSAVER_TIMER, demoMode_widget)

function blockXscreensaver()
  gears.timer {
    timeout   = XSCREENSAVER_TIMER,
    autostart = true,
    callback  = function()
        awful.util.spawn_with_shell(XSCREENSAVER_DEACTIVATE_COMMAND)
        --naughty.notify{ 
         --title= "Notification status",
         --text = tostring(not naughty.is_suspended()),
         --ignore_suspend = true,
       --}
      end,
    single_shot = false,
}
end

demoMode_widget:buttons(awful.util.table.join(
                       awful.button({ }, 1, function () 
                         naughty.toggle()
                         if naughty.is_suspended() then
                           blockXscreensaver()
                           demoMode_widget.bg =  beautiful.fg_urgent
                         else
                           demoMode_widget.bg =  beautiful.bg_normal
                         end
                         --naughty.notify{ 
                           --title= "Notification status",
                           --text = tostring(not naughty.is_suspended()),
                           --ignore_suspend = true,
                         --}
                     end)
                       ))


return demoMode_widget
