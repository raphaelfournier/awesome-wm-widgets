-------------------------------------------------
-- Watson Shell for Awesome Window Manager
-- Simplifies interaction with Watson CLI time tracker
-- More details could be found here:
-- http://tailordev.github.io/Watson/

-- @author Raphaël Fournier-S'niehotta
-- @copyright 2018 Raphaël Fournier-S'niehotta
-------------------------------------------------

local awful = require("awful")
local gfs = require("gears.filesystem")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local ICON = "/home/raph/.config/awesome/themes/myzenburn/watson-icon.png"

local watson_shell = awful.widget.prompt()

local w = wibox {
    bg = beautiful.bg_normal or "#3F3F3F",
    border_width = beautiful.border_width or 5,
    border_color = beautiful.fg_focus or "#F0DFAF",
    max_widget_size = 800,
    ontop = true,
    screen = mouse.screen,
    height = 60,
    width = 500,
    shape = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, 10)
    end
}

w:setup {
    {
        {
            image = ICON,
            widget = wibox.widget.imagebox,
            resize = true
        },
        id = 'icon',
        top = 5,
        left = 5,
        layout = wibox.container.margin
    },
    {
        layout = wibox.container.margin,
        left = 10,
        watson_shell,
    },
    id = 'left',
    layout = wibox.layout.fixed.horizontal
}

local function launch()
    w.visible = true

    awful.placement.top(w, { margins = {top = 60}})
    awful.prompt.run{
        prompt = "<b>Watson</b>: ",
        --bg_cursor = beautiful.fg_normal or "#31b198",
        bg_cursor = "#31b198",
        textbox = watson_shell.widget,
        history_path = gfs.get_dir('cache') .. '/watson_history',
        exe_callback = function(input_text)
            if not input_text or #input_text == 0 then return end
            awful.util.spawn_with_shell("watson " .. input_text)
        end,
        done_callback = function()
            w.visible = false
        end
    }
end

return {
    launch = launch
}
