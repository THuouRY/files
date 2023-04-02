local awesome, client, mouse, screen, tag = awesome, client, mouse, screen, tag
local ipairs, string, os, table, tostring, tonumber, type = ipairs, string, os, table, tostring, tonumber, type

-- Standard awesome library
local gears         = require("gears") --Utilities such as color parsing and objects
local awful         = require("awful") --Everything related to window managment
                      require("awful.autofocus")
-- Widget and layout library
local wibox         = require("wibox")

-- Theme handling library
local beautiful     = require("beautiful")

-- Notification library
local naughty       = require("naughty")
naughty.config.defaults['icon_size'] = 100

local lain          = require("lain")
local freedesktop   = require("freedesktop")

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
local hotkeys_popup = require("awful.hotkeys_popup").widget
                      require("awful.hotkeys_popup.keys")
local my_table      = awful.util.table or gears.table -- 4.{0,1} compatibility

if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end

local function run_once(cmd_arr)
    for _, cmd in ipairs(cmd_arr) do
        awful.spawn.with_shell(string.format("pgrep -u $USER -fx '%s' > /dev/null || (%s)", cmd, cmd))
    end
end

run_once({ "unclutter -root" }) -- entries must be comma-separated

local themes = {
    "powerarrow", -- 1
    "blackburn", -- 1
    "copland", -- 1
    "dremora", -- 1
    "holo", -- 1
    "multicolor", -- 1
    "powerarrow-dark", -- 1
    "rainbow", -- 1
    "steamburn", -- 1
    "vertex", -- 1
}

-- choose your theme here
local chosen_theme = themes[1]
local theme_path = string.format("%s/.config/awesome/themes/%s/theme.lua", os.getenv("HOME"), chosen_theme)
beautiful.init(theme_path)

local modkey      = "Mod4"
local altkey      = "Mod1"
local ctrlkey     = "Control"
local terminal    = "alacritty"
local shell       = "sh"
local browser     = "firefox"
local editor      = os.getenv("EDITOR") or "vim"
local mediaplayer = "mpv"
local soundplayer = "ffplay -nodisp -autoexit " -- The program that will play system sounds

--Screeshot
screenshot = "/home/thuoury/scripts/screenshot.sh"
screenshot_cmd = terminal .. " -e " .. screenshot





-- awesome variables
awful.util.terminal = terminal
awful.util.shell = shell
-- awful.util.tagnames = {  " 1", " 2", " 3", " 4", " 5", " 6", " 7", " 8", " 9"  }
-- awful.util.tagnames = {" ", " ", " ", " ", " ", " ", " ", " ", " "}
-- awful.util.tagnames = {"   ","   ",  "   ", "   ","   " ,  "   ", "   ","   "}
-- awful.util.tagnames = { " WWW ", " DEV ", " LATEX ", " DOC ", " NSFW ", " WAL ", " CHAT ", " WIDWS ", " VBOX " }
awful.util.tagnames = { "  ", " ", " ", " ", " "}
awful.layout.suit.tile.left.mirror = true
awful.layout.layouts = {
    --awful.layout.suit.tile,
    awful.layout.suit.max,
    awful.layout.suit.tile.right,
    awful.layout.suit.magnifier,
    awful.layout.suit.floating,
    -- awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    -- awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
    lain.layout.cascade,
    -- lain.layout.cascade.tile,
    -- lain.layout.centerwork,
    -- lain.layout.centerwork.horizontal,
    -- lain.layout.termfair,
    -- lain.layout.termfair.center,
}
-- local t=;
-- awful.layout.set(awful.layout.layouts[5] ,t=awful.util.tagnames[3])
awful.util.taglist_buttons = my_table.join(
    awful.button({ }, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),
    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

awful.util.tasklist_buttons = my_table.join(
    awful.button({ }, 1, function (c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal("request::activate", "tasklist", {raise = true})
        end
    end),
    awful.button({ }, 3, function ()
        local instance = nil

        return function ()
            if instance and instance.wibox.visible then
                instance:hide()
                instance = nil
            else
                instance = awful.menu.clients({theme = {width = 250}})
            end
        end
    end),
    awful.button({ }, 4, function () awful.client.focus.byidx(1) end),
    awful.button({ }, 5, function () awful.client.focus.byidx(-1) end)
)

lain.layout.termfair.nmaster           = 3
lain.layout.termfair.ncol              = 1
lain.layout.termfair.center.nmaster    = 3
lain.layout.termfair.center.ncol       = 1
lain.layout.cascade.tile.offset_x      = 2
lain.layout.cascade.tile.offset_y      = 32
lain.layout.cascade.tile.extra_padding = 5
lain.layout.cascade.tile.nmaster       = 5
lain.layout.cascade.tile.ncol          = 2

beautiful.init(string.format(gears.filesystem.get_configuration_dir() .. "/themes/%s/theme.lua", chosen_theme))

local myawesomemenu = {
    { "hotkeys", function() return false, hotkeys_popup.show_help end },
    { "manual", terminal .. " -e 'man awesome'" },
    { "edit config", "nvim ~/.config/awesome/rc.lua" },
    { "arandr", "arandr" },
    { "restart", awesome.restart },
}

awful.util.mymainmenu = freedesktop.menu.build({
    icon_size = beautiful.menu_height or 16,
    before = {
        { "Awesome", myawesomemenu, beautiful.awesome_icon },
        --{ "Atom", "atom" },
        -- other triads can be put here
    },
    after = {
        { "Terminal", terminal },
        { "Log out", function() awesome.quit() end },
        { "Sleep", "systemctl suspend" },
        { "Restart", "systemctl reboot" },
        { "Exit", "systemctl poweroff" },
        -- other triads can be put here
    }
})
--menubar.utils.terminal = terminal -- Set the Menubar terminal for applications that require it

--local soundDir = "/opt/dtos-sounds/" -- The directory that has the sound files
--
--local startupSound  = soundDir .. "startup-01.mp3"
--local shutdownSound = soundDir .. "shutdown-01.mp3"
--local dmenuSound    = soundDir .. "menu-01.mp3"

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", function(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end)
-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(function(s) beautiful.at_screen_connect(s) end)

root.buttons(my_table.join(
    awful.button({ }, 3, function () awful.util.mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))

globalkeys = my_table.join(

    -- {{{ Personal keybindings

    -- Awesome keybindings
    awful.key({ modkey,         }, "Return", function () awful.spawn( terminal ) end,
              {description = "Launch terminal", group = "awesome"}),
    awful.key({ modkey,         }, "f", function () awful.spawn( "firefox" ) end,
              {description = "Launch firefox", group = "awesome"}),
    awful.key({ modkey, "Shift" }, "r", awesome.restart,
              {description = "Reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift" }, "q",  function () awful.spawn.with_shell("dm-logout") end,
              {description = "Quit awesome", group = "awesome"}),
    -- awful.key({ modkey,         }, "s",      hotkeys_popup.show_help,
    --     {description = "Show help", group="awesome"}),
    awful.key({ modkey, "Shift" }, "o", function () awful.util.mymainmenu:show() end,
        {description = "Show main menu", group = "awesome"}),
    awful.key({ modkey,  }, "z", function () awful.spawn("zathura") end,
        {description = "run zathura", group = "awesome"}),
    awful.key({ modkey, "Shift" }, "b", function ()
            for s in screen do
                s.mywibox.visible = not s.mywibox.visible
                if s.mybottomwibox then
                    s.mybottomwibox.visible = not s.mybottomwibox.visible
                end
            end
        end,
        {description = "Show/hide wibox (bar)", group = "awesome"}),

--    -- Run launcher
--    awful.key({ modkey, "Shift" }, "Return", function () menubar.show() end,
--      {description = "Run launcher", group = "hotkeys"}),

--    -- Dmscripts (Super + p followed by KEY)
--    awful.key( {modkey}, "p", function()
--      local grabber
--      grabber =
--        awful.keygrabber.run(
--          function(_, key, event)
--            if event == "release" then return end
--
--            if     key == "h" then awful.spawn.with_shell("dm-hub")
--            elseif key == "a" then awful.spawn.with_shell("dm-sounds")
--            elseif key == "b" then awful.spawn.with_shell("dm-setbg")
--            elseif key == "c" then awful.spawn.with_shell("dtos-colorscheme")
--            elseif key == "e" then awful.spawn.with_shell("dm-confedit")
--            elseif key == "i" then awful.spawn.with_shell("dm-maim")
--            elseif key == "k" then awful.spawn.with_shell("dm-kill")
--            elseif key == "m" then awful.spawn.with_shell("dm-man")
--            elseif key == "n" then awful.spawn.with_shell("dm-note")
--            elseif key == "o" then awful.spawn.with_shell("dm-bookman")
--            elseif key == "p" then awful.spawn.with_shell("passmenu -p \"Pass: \"")
--            elseif key == "q" then awful.spawn.with_shell("dm-logout")
--            elseif key == "r" then awful.spawn.with_shell("dm-radio")
--            elseif key == "s" then awful.spawn.with_shell("dm-websearch")
--            elseif key == "t" then awful.spawn.with_shell("dm-translate")
--            end
--            awful.keygrabber.stop(grabber)
--            end
--          )
--        end,
--        {description = "followed by KEY", group = "Dmscripts"}
--        ),


    -- Tag browsing with modkey
    awful.key({ modkey,         }, "Prior",   awful.tag.viewprev,
        {description = "view previous", group = "tag"}),
    awful.key({ modkey,         }, "Next",  awful.tag.viewnext,
        {description = "view next", group = "tag"}),
    awful.key({ altkey,         }, "Escape", awful.tag.history.restore,
        {description = "go back", group = "tag"}),

--     -- Tag browsing ALT+TAB (ALT+SHIFT+TAB)
--    awful.key({ altkey,         }, "Tab", awful.tag.viewnext,
--        {description = "view next", group = "tag"}),
--    awful.key({ altkey, "Shift" }, "Tab", awful.tag.viewprev,
--        {description = "view previous", group = "tag"}),

--    -- Non-empty tag browsing CTRL+TAB (CTRL+SHIFT+TAB)
--    awful.key({ modkey }, "Tab", function () lain.util.tag_view_nonempty(-1) end,
--              {description = "view  previous nonempty", group = "tag"}),
--    awful.key({ ctrlkey, "Shift" }, "Tab", function () lain.util.tag_view_nonempty(1) end,
--              {description = "view  previous nonempty", group = "tag"}),

    -- Default client focus
    awful.key({ modkey,         }, "Tab", function () awful.client.focus.byidx( 1) end,
        {description = "Focus next by index", group = "client"}),
    awful.key({ modkey,"Shift"  }, "Tab", function () awful.client.focus.byidx(-1) end,
       {description = "Focus previous by index", group = "client"}),

    -- By direction client focus
    awful.key({ altkey }, "j", function() awful.client.focus.global_bydirection("down")
        if client.focus then client.focus:raise() end end,
        {description = "Focus down", group = "client"}),
    awful.key({ altkey }, "k", function() awful.client.focus.global_bydirection("up")
        if client.focus then client.focus:raise() end end,
        {description = "Focus up", group = "client"}),
    awful.key({ altkey }, "h", function() awful.client.focus.global_bydirection("left")
        if client.focus then client.focus:raise() end end,
        {description = "Focus left", group = "client"}),
    awful.key({ altkey }, "l", function() awful.client.focus.global_bydirection("right")
        if client.focus then client.focus:raise() end end,
        {description = "Focus right", group = "client"}),

        -- By direction client focus with arrows
    -- awful.key({  modkey }, "j", function() awful.client.focus.global_bydirection("down")
    --     if client.focus then client.focus:raise() end end,
    --     {description = "Focus down", group = "client"}),
    -- awful.key({  modkey }, "k", function() awful.client.focus.global_bydirection("up")
    --     if client.focus then client.focus:raise() end end,
    --     {description = "Focus up", group = "client"}),
    -- awful.key({  modkey }, "h", function() awful.client.focus.global_bydirection("left")
    --     if client.focus then client.focus:raise() end end,
    --     {description = "Focus left", group = "client"}),
    -- awful.key({  modkey }, "l", function() awful.client.focus.global_bydirection("right")
    --     if client.focus then client.focus:raise() end end,
    --     {description = "Focus right", group = "client"}),

    -- Layout manipulation
    awful.key({ altkey, "Shift" }, "l", function () awful.client.swap.byidx(1) end,
        {description = "swap with next client by index", group = "client"}),
    awful.key({ altkey, "Shift" }, "h", function () awful.client.swap.byidx( -1) end,
        {description = "swap with previous client by index", group = "client"}),
    --awful.key({ modkey          }, "h", function () awful.screen.focus_relative(1) end,
    --    {description = "focus the next screen", group = "screen"}),
    --awful.key({ modkey          }, ",", function () awful.screen.focus_relative(-1) end,
    --    {description = "focus the previous screen", group = "screen"}),
    --awful.key({ modkey,         }, "u", awful.client.urgent.jumpto,
    --    {description = "jump to urgent client", group = "client"}),
    ----------------awful.key({ ctrlkey,        }, "Tab", function () awful.client.focus.history.previous()
     --   if client.focus then client.focus:raise() end end,
     --   {description = "go back", group = "client"}),

    -- On the fly useless gaps change
    awful.key({ altkey, ctrlkey }, "j", function () lain.util.useless_gaps_resize(1) end,
        {description = "increment useless gaps", group = "tag"}),
    awful.key({ altkey, ctrlkey }, "k", function () lain.util.useless_gaps_resize(-1) end,
        {description = "decrement useless gaps", group = "tag"}),

    -- Dynamic tagging
    awful.key({ modkey, "Shift" }, "n", function () lain.util.add_tag() end,
        {description = "add new tag", group = "tag"}),
    awful.key({ modkey, ctrlkey }, "r", function () lain.util.rename_tag() end,
        {description = "rename tag", group = "tag"}),
    awful.key({ modkey, "Shift" }, "Prior", function () lain.util.move_tag(-1) end,
        {description = "move tag to the left", group = "tag"}),
    awful.key({ modkey, "Shift" }, "Next", function () lain.util.move_tag(1) end,
        {description = "move tag to the right", group = "tag"}),
    awful.key({ modkey, "Shift" }, "d", function () lain.util.delete_tag() end,
        {description = "delete tag", group = "tag"}),

   --  awful.key({ ctrlkey , "Shift"}, "Right", function () awful.tag.incmwfact( 0.05) end,
   --     {description = "increase master width factor", group = "layout"}),
   -- awful.key({ ctrlkey , "Shift"}, "Left", function () awful.tag.incmwfact(-0.05) end,
   --     {description = "decrease master width factor", group = "layout"}),
    awful.key({ ctrlkey, "Shift"    }, "h",     function () awful.tag.incmwfact( 0.01)    end),
    awful.key({ ctrlkey, "Shift"    }, "l",     function () awful.tag.incmwfact(-0.01)    end),
    awful.key({ ctrlkey, "Shift"    }, "j",     function () awful.client.incwfact( 0.01)    end),
    awful.key({ ctrlkey, "Shift"    }, "k",     function () awful.client.incwfact(-0.01)    end),
   -- awful.key({ ctrlkey, "Shift" }, "Up", function () awful.tag.incnmaster( 1, nil, true) end,
   --     {description = "increase the number of master clients", group = "layout"}),
   -- awful.key({ modkey, "Shift" }, "Down", function () awful.tag.incnmaster(-1, nil, true) end,
   --     {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, ctrlkey }, "h", function () awful.tag.incncol( 1, nil, true) end,
        {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, ctrlkey }, "l", function () awful.tag.incncol(-1, nil, true) end,
        {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,         }, "l", function () awful.layout.inc( 1) end,
        {description = "select next", group = "layout"}),
    awful.key({ modkey,         }, "t", function () awful.layout.set(awful.layout.suit.magnifier) end,
        {description = "select next", group = "layout"}),
    awful.key({ modkey,         }, "m", function () awful.layout.set(awful.layout.suit.max) end,
        {description = "select next", group = "layout"}),

    awful.key({ modkey }, "r",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                      client.focus = c
                      c:raise()
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Dropdown application
  --  awful.key({ modkey, }, "F12", function () awful.screen.focused().quake:toggle() end,
  --            {description = "dropdown application", group = "super"}),

--    -- Widgets popups
    awful.key({ altkey, }, "c", function () lain.widget.cal.show(0) end,
        {description = "show calendar", group = "widgets"}),
--    awful.key({ altkey, }, "h", function () if beautiful.fs then beautiful.fs.show(7) end end,
--        {description = "show filesystem", group = "widgets"}),
--    awful.key({ altkey, }, "w", function () if beautiful.weather then beautiful.weather.show(7) end end,
--        {description = "show weather", group = "widgets"}),

    -- Brightness
    awful.key({ }, "XF86MonBrightnessUp", function () os.execute("xbacklight -inc 7") end,
        {description = "+7%", group = "hotkeys"}),
     awful.key({ }, "XF86MonBrightnessDown", function () os.execute("xbacklight -dec 7") end,
        {description = "-7%", group = "hotkeys"}),
     awful.key({ modkey , "Shift"}, "z", function () os.execute("pamixer --allow-boost --increase 5") end,
        {description = "+5%vol", group = "hotkeys"}),

    -- Screeshot---------------

    
    awful.key({ modkey  ,         }, "#107", function () os.execute("scrot -s '%Y-%m-%d_$wx$h_scrot.png' -e 'mv $f /home/thuoury/Pictures/Screeshots/'") end,
          {description = "take screenshot", group = "launcher"}),
    awful.key({ modkey  ,  }, "s", function () os.execute("scrot -s '/home/thuoury/Pictures/Screeshots/%F_%T_schoot.png' -e 'xclip -selection clipboard -target image/png -i $f'")  end,
          {description = "take screenshot", group = "launcher"}),
    awful.key({ modkey  ,  }, "p", function () os.execute("scrot -s '/home/thuoury/Pictures/Screeshots/%F_%T_schoot.png' -e 'xclip -selection clipboard -target image/png -i $f && rm $f'")  end,
          {description = "take screenshot", group = "launcher"}),

    --Wallpaper -------------------------------------------------------
    awful.key({ modkey , "Shift"}, "w", function () os.execute("feh --randomize --bg-fill /home/thuoury/Desktop/wallpaper/*") end,
        {description = "change wallpaper", group = "hotkeys"}),
	
   -- Lock screen -----------------------------
    awful.key({ modkey , "Shift" }, "l", function () os.execute("betterlockscreen -l --off 5 --display") end,
        {description = "change wallpaper", group = "hotkeys"}),

  -- Mocp music ------------------------------------------
    awful.key({ altkey , "Shift" }, "m", function () awful.spawn("alacritty -e mocp -R alsa $HOME/Desktop/Music/") end,
        {description = "music player", group = "hotkeys"}),

    awful.key({altkey}, "n", function () awful.spawn("mocp -f") end,
        {description = "music player next", group = "hotkeys"}),
    awful.key({altkey , "Shift"}, "n", function () awful.spawn("mocp -r") end,
        {description = "music player previous", group = "hotkeys"}),
    awful.key({altkey }, "p", function () awful.spawn("mocp -G") end,
        {description = "music player next", group = "hotkeys"}),
  -------Blutooth connection -----------------------------
    awful.key({altkey }, "b", function ()   os.execute("/home/thuoury/.local/bin/blth.sh") end,
        {description = "connect to cassque", group = "hotkeys"}),
  -------take notes ---------------------------------------------------
    awful.key({modkey }, "n", function ()   awful.spawn("xfce4-terminal -e /home/thuoury/.local/bin/notes") end,
        {description = "take notes", group = "hotkeys"}),
    awful.key({modkey }, "e", function ()   awful.spawn("xfce4-terminal -e /home/thuoury/.local/bin/nt.sh ") end,
        {description = "take notes S4", group = "hotkeys"}),
    awful.key({modkey,"Shift" }, "p", function ()   awful.spawn("xfce4-terminal -e /usr/bin/python3") end,
        {description = "spawn python", group = "hotkeys"}),
  ---- nnn file manager -----------------------------------
    -- awful.key({ modkey ,  }, "n", function () awful.spawn.with_shell("alacritty -e /usr/bin/zsh -c nnn -e") end,
    --     {description = "nnn file manager", group = "hotkeys"}),
    awful.key({ altkey ,  }, "r", function () awful.spawn.with_shell("alacritty -e ranger 2>/dev/null") end,
        {description = "ranger file manager", group = "hotkeys"}),
    awful.key({ modkey ,  }, "v", function () awful.spawn("alacritty -e nvim") end,
        {description = "spawn nvim", group = "hotkeys"}),
 -- rofii --------------------------------- 
    awful.key({ modkey ,"Shift"  }, "Return", function () awful.spawn.with_shell("rofi -combi-modi window,drun,combi -show combi -icon-theme 'Dracula' -show-icons") end,
        {description = "nnn file manager", group = "hotkeys"}),
  -- 
    -- ALSA volume control
    --awful.key({ ctrlkey }, "Up",
    awful.key({ }, "XF86AudioRaiseVolume",
        function ()
            os.execute(string.format("amixer -q set %s 5%%+", beautiful.volume.channel))
            beautiful.volume.update()
        end),
    --awful.key({ ctrlkey }, "Down",
    awful.key({ }, "XF86AudioLowerVolume",
        function ()
            os.execute(string.format("amixer -q set %s 5%%-", beautiful.volume.channel))
            beautiful.volume.update()
        end),
    awful.key({ }, "XF86AudioMute",
        function ()
            os.execute(string.format("amixer -q set %s toggle", beautiful.volume.togglechannel or beautiful.volume.channel))
            beautiful.volume.update()
        end)

    -- Copy primary to clipboard (terminals to gtk)
    -- awful.key({ modkey }, "c", function () awful.spawn.with_shell("xsel | xsel -i -b") end,
    --     {description = "copy terminal to gtk", group = "hotkeys"}),
    -- -- Copy clipboard to primary (gtk to terminals)
    -- awful.key({ modkey }, "v", function () awful.spawn.with_shell("xsel -b | xsel") end,
    --     {description = "copy gtk to terminal", group = "hotkeys"})
)

clientkeys = my_table.join(
    awful.key({ altkey, "Shift"  }, "m",      lain.util.magnify_client,
              {description = "magnify client", group = "client"}),
    awful.key({ modkey, }, "q", function (c) c:kill() end,
      {description = "close", group = "hotkeys"}),
    -- awful.key({ modkey,         }, "t", awful.client.floating.toggle,
    --   {description = "toggle floating", group = "client"}),
    awful.key({ modkey,      }, "d",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
    {description = "minimize", group = "client"}),
    awful.key({ modkey, "Shift" }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
    {description = "maximize", group = "client"}),
    awful.key({modkey , "ctrlkey"}, "Right" ,
    function(c)
      local axis = 'vertically'
      local f = awful.placement.scale + awful.placement.right + awful.placement.maximize_vertically  + (axis and awful.placement['maximize_'..axis] or nil)
      f(c.focus, {honor_workarea=true, to_percent = 0.5})
    end,
    {description = "maximize_vertically to the right ", group = "client"})

)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    -- Hack to only show tags 1 and 9 in the shortcut window (mod+s)
    local descr_view, descr_toggle, descr_move, descr_toggle_focus
    if i == 1 or i == 9 then
        descr_view = {description = "view tag #", group = "tag"}
        descr_toggle = {description = "toggle tag #", group = "tag"}
        descr_move = {description = "move focused client to tag #", group = "tag"}
        descr_toggle_focus = {description = "toggle focused client on tag #", group = "tag"}
    end
    globalkeys = my_table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  descr_view),
        -- Toggle tag display.
        awful.key({ modkey, ctrlkey }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  descr_toggle),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  descr_move),
        -- Toggle tag on focused client.
        awful.key({ modkey, ctrlkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  descr_toggle_focus)
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)

-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen,
                     size_hints_honor = false
     }
    },

    -- Titlebars
    { rule_any = { type = { "dialog", "normal" } },
      properties = { titlebars_enabled = false } },

    -- Set applications to always map on the tag 1 on screen 1.
    -- find class or role via xprop command
    { rule = { class = "Chromium" },
      properties = {  opacity = 0.1, screen = 1, tag = awful.util.tagnames[2], floating= true, placement = awful.placement.centered, maximized = false, width = 900, height = 542 } },
  --   
  { rule = { class = "discord" },
      properties = {  screen = 1, tag = awful.util.tagnames[2], floating= true, maximized = false, width = 900, height = 500, placement = awful.placement.centered } },
  { rule = { class = {"telegram-desktop","TelegramDesktop"} },
      properties = {  screen = 1, tag = awful.util.tagnames[2], floating= true, maximized = false, width = 900, height = 500, placement = awful.placement.centered } },

{ rule = {name = "conky (ArchSier)" },
  properties = {  below=true, border_width = 0 , immobilized=false, is_fixed =true }},

-- { rule = {name = "cava" },
--   properties = {  below=true, border_width = 0 , immobilized=false, is_fixed =true }},
    --{ rule = { class = editorgui },
        --properties = { screen = 1, tag = awful.util.tagnames[2] } },

    --{ rule = { class = "Geany" },
        --properties = { screen = 1, tag = awful.util.tagnames[2] } },

    -- Set applications to always map on the tag 3 on screen 1.
    --{ rule = { class = "Inkscape" },
        --properties = { screen = 1, tag = awful.util.tagnames[3] } },

    -- Set applications to always map on the tag 4 on screen 1.
    --{ rule = { class = "Gimp" },
        --properties = { screen = 1, tag = awful.util.tagnames[4] } },

    -- Set applications to be maximized at startup.
    -- find class or role via xprop command

    -- { rule = { class = "Gimp*", role = "gimp-image-window" },
    --       properties = { maximized = true } },
    --
    -- { rule = { class = "inkscape" },
    --       properties = { maximized = true } },
    --
    -- { rule = { class = mediaplayer },
    --       properties = { maximized = true } },
    --
    -- { rule = { class = "Vlc" },
    --       properties = { maximized = true } },
    --
    -- { rule = { class = "VirtualBox Manager" },
    --       properties = { maximized = true } },
    --
    -- { rule = { class = "VirtualBox Machine" },
    --       properties = { maximized = true } },
    --
     { rule = { class = "Xfce4-terminal" },
           properties = { floating = true, placement = awful.placement.centered, width = 800, height = 450,maximized = false} },
     -- { rule = {  },
     --       properties = { floating = true, placement = centered, maximized = false} },



    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
        },
        class = {
"DigitalSignature",
          "Arandr",
          "Blueberry",
          "Galculator",
          "Gnome-font-viewer",
          "Gpick",
          "Imagewriter",
          "Font-manager",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Oblogout",
          "Peek",
          "Skype",
          "System-config-printer.py",
          -- "Sxiv",
          "Unetbootin.elf",
          "Wpa_gui",
          "pinentry",
          "veromix",
          "xtightvncviewer"},

        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
          "Preferences",
          "setup",
        }
      }, properties = { floating = true }},

}

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- Custom
    if beautiful.titlebar_fun then
        beautiful.titlebar_fun(c)
        return
    end

    -- Default
    -- buttons for the titlebar
    local buttons = my_table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c, {size = 21}) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
          {
        
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
          },
            margins = 7,
            widget = wibox.container.margin
        },
        layout = wibox.layout.align.horizontal,
    }
end)

client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = true})
end)

-- No border for maximized clients
function border_adjust(c)
    if c.maximized then -- no borders if only 1 client visible
        c.border_width = 0
    elseif #awful.screen.focused().clients > 1 then
        c.border_width = beautiful.border_width
        c.border_color = beautiful.border_focus
    end
end

client.connect_signal("focus", border_adjust)
client.connect_signal("property::maximized", border_adjust)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

--awful.spawn.with_shell(soundplayer .. startupSound)
awful.spawn.with_shell("lxsession")
-- awful.spawn.with_shell("nm-applet")
awful.spawn.with_shell("volumeicon")

awful.spawn.with_shell("~/.fehbg") -- set last saved feh wallpaper
-- awful.spawn.with_shell("~/.conky/conky-startup.sh") -- set last saved feh wallpaper
--awful.spawn.with_shell("feh --randomize --bg-fill /home/thuoury/Desktop/wallpaper/*") -- feh sets random wallpaper
--awful.spawn.with_shell("sxhkd -c $HOME/.config/sxhkd/sxhkdrc")
-- awful.spawn.with_shell('xinput set-prop "SynPS/2 Synaptics TouchPad" "libinput Tapping Enabled" 1')
--awful.spawn.with_shell("nitrogen --restore") -- if you prefer nitrogen to feh/xwallpaper
package.loaded["naughty.dbus"] = {}
