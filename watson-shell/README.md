# README

After Spotify Shell from https://github.com/streetturtle/awesome-wm-widgets,
this is a prompt for the Awesome Window Manager to interact with Watson Time
Tracker (http://tailordev.github.io/Watson/).

## Features

1. Send commands to Watson, without checking them. So it's mostly to have a
   convenient way to type `watson start foobar project +bartag`. There is no
   feedback, so `watson log` won't work at the moment.

1. Stores history and allows navigate through it;

1. Highly customizable

## Controls

Keyboard navigation (copied from [`awful.prompt`](https://awesomewm.org/doc/api/libraries/awful.prompt.html) API documentation page):

| Name | Usage |
|---|---|
| CTRL+A | beginning-of-line |
| CTRL+B | backward-char |
| CTRL+C | cancel |
| CTRL+D | delete-char |
| CTRL+E | end-of-line |
| CTRL+J | accept-line |
| CTRL+M | accept-line |
| CTRL+F | move-cursor-right |
| CTRL+H | backward-delete-char |
| CTRL+K | kill-line |
| CTRL+U | unix-line-discard |
| CTRL+W | unix-word-rubout |
| CTRL+BACKSPAC | unix-word-rubout |
| SHIFT+INSERT | paste |
| HOME | beginning-of-line |
| END | end-of-line |
| CTRL+R | reverse history search, matches any history entry containing search term. |
| CTRL+S | forward history search, matches any history entry containing search term. |
| CTRL+UP | ZSH up line or search, matches any history entry starting with search term. |
| CTRL+DOWN | ZSH down line or search, matches any history entry starting with search term. |
| CTRL+DELETE | delete the currently visible history entry from history file. This does not delete new commands or history entries under user editing. |


## Installation

1. Require watson-shell at the beginning of **rc.lua**:

    ```lua
    local watson_shell = require("awesome-wm-widgets.watson-shell.watson-shell")
    ```

1. You may add a shortcut which will show Watson Shell widget:

    ```lua
    awful.key({ modkey,        }, "d", function () watson_shell.launch() end, {description = "watson shell", group = "music"}),
    ```

1. You may also use it with the Watson Arc Widget, which display in a beautiful
   manner the length of your working time.
