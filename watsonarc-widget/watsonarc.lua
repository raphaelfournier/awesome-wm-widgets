-------------------------------------------------
-- Watson Arc Widget for Awesome Window Manager
--
-- Modelled after Pavel Makhov's work
-- See his github repo: https://github.com/streetturtle/awesome-wm-widgets/

-- @author Raphaël Fournier-S'niehotta
-- @copyright 2018 Raphaël Fournier-S'niehotta
-------------------------------------------------

local awful = require("awful")
local beautiful = require("beautiful")
local spawn = require("awful.spawn")
local watch = require("awful.widget.watch")
local wibox = require("wibox")
local naughty = require("naughty")
local watson_shell = require("awesome-wm-widgets.watson-shell.watson-shell")

local GET_watson_CMD = "/usr/bin/watson status"
local START_watson_CMD = "/usr/bin/watson restart"
local STOP_watson_CMD = "/usr/bin/watson stop"

local PATH_TO_ICONS = "/home/raph/.config/awesome/themes/myzenburn/"

local PLAY_ICON_NAME = PATH_TO_ICONS .. "play.png"
local STOP_ICON_NAME = PATH_TO_ICONS .. "stop.png"

function splittokens(s)
    local res = {}
    for w in s:gmatch("%S+") do
        res[#res+1] = w
    end
    return res
end

function textwrap(text, linewidth)
    if not linewidth then
        linewidth = 75
    end

    local spaceleft = linewidth
    local res = {}
    local line = {}

    for _, word in ipairs(splittokens(text)) do
        if #word + 1 > spaceleft then
            table.insert(res, table.concat(line, ' '))
            line = {word}
            spaceleft = linewidth - #word
        else
            table.insert(line, word)
            spaceleft = spaceleft - (#word + 1)
        end
    end

    table.insert(res, table.concat(line, ' '))
    return table.concat(res, '\n')
end

local icon = wibox.widget { 
        id = "icon",
        widget = wibox.widget.imagebox,
        image = PLAY_ICON_NAME
    }
local mirrored_icon = wibox.container.mirror(icon, { horizontal = true })

local watsonarc = wibox.widget {
    mirrored_icon,
    max_value = 1,
    thickness = 2,
    start_angle = 4.71238898, -- 2pi*3/4
    forced_height = 32,
    forced_width = 32,
    rounded_edge = true,
    bg = "#ffffff11",
    paddings = 0,
    widget = wibox.container.arcchart
}

local watsonarc_widget = wibox.container.mirror(watsonarc, { horizontal = true })

local update_graphic = function(widget, stdout, _, _, _)
    stdout = string.gsub(stdout, "\n", "")
    local state = string.match(stdout, "^No project")
    local project = string.match(stdout, "Project (%a+) ")
    local minutes = tonumber(string.match(stdout, "started (%d?%d) minutes")) or 2

    if state == "No project" then 
      icon.image = STOP_ICON_NAME
      widget.value = 1
    else
      icon.image = PLAY_ICON_NAME
      widget.colors = { beautiful.widget_main_color }
      if tonumber(minutes) >= 2 
      then
        widget.value = tonumber(minutes)/60
      end
    end
end

watsonarc:connect_signal("button::press", 
  function(_, _, _, button)
    if (button == 2) then watson_shell.launch()
    elseif (button == 1) then awful.spawn(START_watson_CMD, false)
    elseif (button == 3) then awful.spawn(STOP_watson_CMD, false)
    end

    spawn.easy_async(GET_watson_CMD, 
      function(stdout, stderr, exitreason, exitcode)
      update_graphic(watsonarc, stdout, stderr, exitreason, exitcode)
      end
    )

end)

local notification
function show_watson_status()
    spawn.easy_async(GET_watson_CMD,
        function(stdout, _, _, _)
            notification = naughty.notify {
                text = textwrap(stdout,60),
                title = "Watson status",
                timeout = 5,
                hover_timeout = 0.5,
                --height = 100,
            }
        end)
end

watsonarc:connect_signal("mouse::enter", function() show_watson_status() end)
watsonarc:connect_signal("mouse::leave", function() naughty.destroy(notification) end)

watch(GET_watson_CMD, 10, update_graphic, watsonarc)

return watsonarc_widget
