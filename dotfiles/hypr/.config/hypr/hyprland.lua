--[[
DISCLAIMER !!!
These keybinds are meant to work with
my split keyboard in mind, so some
binds might seem unintuitive.

I also still change keys & binds,
so take that into consideration.

ZSA Moonlander config (MAY BE OLD VERSION):
https://configure.zsa.io/moonlander/layouts/0N5XK/yoXWm0/0
]]

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------



-------------------------------
---- MONITORS & WORKSPACES ----
-------------------------------

-- Home
-- 1) Laptop  16:10 1440p Bottom, Landscape secondary 123
-- 2) LG      16:9  1440p Top,    Landscape PRIMARY   456
-- 3) Iiyama  9:16  1080p Right,  Portrait  tertiary  789

-- Internship
-- 1) Laptop  16:10 1440p Right,  Landscape secondary 123
-- 2) Lenovo  16:9  1440p Center, Landscape PRIMARY   456
-- 3) LG      16:9  1080p Left,   Landscape tertiary  789

-- Laptop
hl.monitor({
    output   = "desc:California Institute of Technology 0x1600",
    mode     = "2560x1600@165.01900",
    position = "0x1440",
    scale    = "1.25",
    cm       = "srgb",
    bitdepth = 8
})


-- LG - Home
hl.monitor({
    output   = "desc:LG Electronics LG ULTRAGEAR 309MAHUDPQ89",
    mode     = "2560x1440@143.93300",
    position = "0x0",
    scale    = "1",
    cm       = "srgb",
    bitdepth = 8
})
-- Iiyama - Home
hl.monitor({
    output    = "desc:Iiyama North America PL2466H 1177004102878",
    mode      = "1920x1080@60.00000",
    position  = "2560x0",
    scale     = "1",
    cm        = "srgb",
    bitdepth  = 8,
    transform = 3 -- Right is up, Left is down
})


-- Lenovo - Internship
hl.monitor({
    output   = "desc:Lenovo Group Limited P27h-20 V90CBDE4",
    position = "2048x1440",
    scale    = "1",
    cm       = "srgb",
    bitdepth = 8
})
-- LG - Internship
hl.monitor({
    output   = "desc:LG Electronics IPS235 Serial Number",
    position = "4608x1440",
    scale    = "1",
    cm       = "srgb",
    bitdepth = 8,
    transform = 3 -- Right is up, Left is down
})

-- Laptop workspaces (Always)
hl.workspace_rule({ workspace = "1", monitor = "desc:California Institute of Technology 0x1600", default = true })
hl.workspace_rule({ workspace = "2", monitor = "desc:California Institute of Technology 0x1600", default = true })
hl.workspace_rule({ workspace = "3", monitor = "desc:California Institute of Technology 0x1600", default = true })

local function apply_home_workspaces()
    hl.workspace_rule({ workspace = "4", monitor = "desc:LG Electronics LG ULTRAGEAR 309MAHUDPQ89", default = true })
    hl.workspace_rule({ workspace = "5", monitor = "desc:LG Electronics LG ULTRAGEAR 309MAHUDPQ89", default = true })
    hl.workspace_rule({ workspace = "6", monitor = "desc:LG Electronics LG ULTRAGEAR 309MAHUDPQ89", default = true })
    hl.workspace_rule({ workspace = "7", monitor = "desc:Iiyama North America PL2466H 1177004102878", default = true })
    hl.workspace_rule({ workspace = "8", monitor = "desc:Iiyama North America PL2466H 1177004102878", default = true })
    hl.workspace_rule({ workspace = "9", monitor = "desc:Iiyama North America PL2466H 1177004102878", default = true })
end

local function apply_internship_workspaces()
    hl.workspace_rule({ workspace = "4", monitor = "desc:Lenovo Group Limited P27h-20 V90CBDE4", default = true })
    hl.workspace_rule({ workspace = "5", monitor = "desc:Lenovo Group Limited P27h-20 V90CBDE4", default = true })
    hl.workspace_rule({ workspace = "6", monitor = "desc:Lenovo Group Limited P27h-20 V90CBDE4", default = true })
    hl.workspace_rule({ workspace = "7", monitor = "desc:LG Electronics IPS235 Serial Number", default = true })
    hl.workspace_rule({ workspace = "8", monitor = "desc:LG Electronics IPS235 Serial Number", default = true })
    hl.workspace_rule({ workspace = "9", monitor = "desc:LG Electronics IPS235 Serial Number", default = true })
end

hl.on("monitor.added", function(m)
    if m.description:find("LG ULTRAGEAR", 1, true) then
        apply_home_workspaces()
    elseif m.description:find("Lenovo Group Limited P27h-20", 1, true) then
        apply_internship_workspaces()
    end
end)

-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function ()
    hl.exec_cmd("gsettings set org.gnome.desktop.interface gtk-theme \"Adwaita-dark\"") -- TODO: Still needed?
    hl.exec_cmd("gsettings set org.gnome.desktop.interface color-scheme \"prefer-dark\"") -- TODO: Still needed?

    hl.exec_cmd("waybar & hyprpaper & hypridle & hyprshot & hyprsunset")
    hl.exec_cmd("swaync") -- Notification Daemon
    hl.exec_cmd("wl-paste --watch cliphist store") -- Save Wayland clipboard entries to cliphist
    hl.exec_cmd("kwalletd6") -- TODO: Still needed? was for Brave not remembering logins/cookies/sessions


    hl.exec_cmd("sleep 5; anki", { workspace = "4 silent" })

    hl.exec_cmd("sleep 5; brave", { workspace = "7 silent" })
    hl.exec_cmd("sleep 5; spotify", { workspace = "9 silent" })
end)



---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER" -- Sets "Windows" key as main modifier

-- ------------------------
-- Top row | Common apps --
-- ------------------------
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd("ghostty"))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("brave"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("dolphin"))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("anki"))
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd("obsidian"))
hl.bind(mainMod .. " + Y", hl.dsp.exec_cmd("spotify"))

-- ------------------------------------------------- --
-- Home row | OS behavior, Window behavior & STT --
-- ------------------------------------------------- --

-- Media Controls (Quickbind)
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("playerctl play-pause")) -- 2 entries, this one is for 8BitDo controller support, other is "XF86AudioPause"
hl.bind(mainMod .. " + SHIFT + A",  hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind(mainMod .. " + CTRL + A",  hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- Screenshot (Quickbind)
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd("hyprshot -m output -o $HOME/images/screenshots/$(date +%Y-%m)")) -- 2 entries, other is 'PRINT'
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("hyprshot -m region -o $HOME/images/screenshots/$(date +%Y-%m)")) -- 2 entries, other is 'PRINT .. " + SHIFT'
hl.bind(mainMod .. " + CTRL + S", hl.dsp.exec_cmd("hyprshot -m window -o $HOME/images/screenshots/$(date +%Y-%m)")) -- 2 entries, other is 'PRINT .. " + CTRL'

-- TODO: Add custom pomodoro timer controls
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(""))

hl.bind(mainMod .. " + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + G", hl.dsp.window.pseudo()) -- dwindle, float in center

hl.bind(mainMod .. " + H", hl.dsp.exec_cmd("arecord -f cd -t wav /tmp/stt_recording.wav"))
hl.bind(mainMod .. " + H", hl.dsp.exec_cmd("bash $HOME/.config/hypr/scripts/stt.sh"), { release = true })

-- ---------------------------
-- Bottom row | OS behavior --
-- ---------------------------
hl.bind(mainMod .. " + Z", hl.dsp.exec_cmd(""))
hl.bind(mainMod .. " + X", hl.dsp.exec_cmd(""))

hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.exec_cmd("hyprpicker -a"))

hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("cliphist list | rofi -dmenu -display-columns 2 | cliphist decode | wl-copy # Show clipboard")) -- Show clipboard in Rofi
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd("cliphist wipe")) -- Wipe cliphist

hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("pkill -USR1 waybar")) -- Toggle Waybar
hl.bind(mainMod .. " + SHIFT + B", hl.dsp.exec_cmd("pkill -USR2 waybar; pkill hyprpaper; hyprpaper &")) -- Reload Waybar & Hyprpaper

hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("rofi -show emoji -modi emoji"))

-- -----------------------------------------------------------
-- Right side: Number row, Right hand & Numpad | Workspaces --
-- -----------------------------------------------------------
local workspaces = {
    { "1", "M",      "code:87" },
    { "2", "COMMA",  "code:88" },
    { "3", "PERIOD", "code:89" },

    { "4", "J",      "code:83" },
    { "5", "K",      "code:84" },
    { "6", "L",      "code:85" },

    { "7", "U",      "code:79" },
    { "8", "I",      "code:80" },
    { "9", "O",      "code:81" },
}

-- ws       = outer loop index, starts at 1 (Lua default)
-- keyGroup = current row in workspaces (inner table)
-- key      = current string value in keyGroup
for ws, keyGroup in ipairs(workspaces) do
    for _, key in ipairs(keyGroup) do
        hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = ws }))
        hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = ws }))
    end
end

-- -------------------------------
-- Rightmost | Common documents --
-- -------------------------------
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("okular $HOME/documents/reading/lpic-1.pdf"))
hl.bind(mainMod .. " + EQUAL", hl.dsp.exec_cmd("okular -p 634  $HOME/documents/reading/lpic-1.pdf")) -- Review question answers

hl.bind(mainMod .. " + SEMICOLON", hl.dsp.exec_cmd(""))
hl.bind(mainMod .. " + APOSTROPHE", hl.dsp.exec_cmd(""))

hl.bind(mainMod .. " + SLASH", hl.dsp.exec_cmd(""))
hl.bind(mainMod .. " + BACKSLASH", hl.dsp.exec_cmd("onlyoffice-desktopeditors $HOME/documents/reading/jb-refererencecard.odg"))

-- ----------
-- Special --
-- ----------
hl.bind(mainMod .. " + ESCAPE", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + SUPER_L", hl.dsp.exec_cmd("pkill rofi || rofi -show drun -show-icons"), { release = true }) -- open on first, closes on second
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd("$HOME/.config/hypr/scripts/pinnedMenu.sh"))

-- Screenshot (dedicated keyboard PrtSc)
hl.bind("PRINT", hl.dsp.exec_cmd("hyprshot -m output -o $HOME/images/screenshots/$(date +%Y-%m)")) -- 2 entries, other is 'mainmod .. " + S"'
hl.bind("SHIFT + PRINT", hl.dsp.exec_cmd("hyprshot -m region -o $HOME/images/screenshots/$(date +%Y-%m)")) -- 2 entries, other is 'mainmod .. " + SHIFT + S"'
hl.bind("CTRL + PRINT", hl.dsp.exec_cmd("hyprshot -m window -o $HOME/images/screenshots/$(date +%Y-%m)")) -- 2 entries, other is 'mainmod .. " + CTRL + S"'

-- Move focus
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })

hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true }) -- 2 entries, other is 'mainmod .. " + A"'
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true }) -- 2 entries, other is 'mainmod .. " + A"'
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })


---------------
---- INPUT ----
---------------
hl.config({
    input = {
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        follow_mouse = 1,

        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

        touchpad = {
            natural_scroll = false,
        }
    }
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})

hl.device({
    name      = "wacom-intuos-s-pen",
    output    = "current",
    transform = 0
})


-----------------------
---- LOOK AND FEEL ----
-----------------------
hl.config({
    general = {
        gaps_in  = 0,
        gaps_out = 0,
        border_size = 0,

        layout = "dwindle"
    },

    decoration = {
        rounding       = 0,
        rounding_power = 2,

        blur = {
            enabled   = true,
            size      = 1,
            passes    = 1,
            noise     = 0.025
        },

        shadow = {
            enabled        = false,
            range          = 2,
            render_power   = 2,
            sharp          = false,
            color          = "rgba(0000FFFF)",
            color_inactive = "rgba(00FF00FF)",
            offset         = {0,0},
            scale          = 1.0
        },

        glow = {
            enabled = true,
            range = 6,
            color = "rgba(FFFFFF43)",
            --color = "rgba(FFAE0088)";
            color_inactive = "rgba(00000088)",
            --color_inactive = "rgba(000000ff)",
        }
    },

    animations = {
        enabled = true
    }
})

hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}    } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })

-- No springyness (updated since 0.56)
hl.curve("easy", { type = "spring", mass = 1, stiffness = 480, dampening = 40 })

hl.animation({ leaf = "global",        enabled = true,  speed = 100,   bezier = "default" }) -- Default = 10
hl.animation({ leaf = "border",        enabled = true,  speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true,  speed = 4.79, spring = "easy" })
hl.animation({ leaf = "windowsIn",     enabled = true,  speed = 4.1,  spring = "easy",         style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true,  speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true,  speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true,  speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true,  speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true,  speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true,  speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true,  speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true,  speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true,  speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true,  speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true,  speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true,  speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor",    enabled = true,  speed = 7,    bezier = "quick" })

hl.config({
    xwayland = {
        force_zero_scaling = true
    },
    dwindle = {
        preserve_split = true
    },
    master = {
        new_status = "master"
    },
    scrolling = {
        fullscreen_on_one_column = true
    },
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo   = true
    }
})

-----------------------------
---- CUSTOM APP BEHAVIOR ----
-----------------------------

local suppressMaximizeRule = hl.window_rule({
    -- Ignore maximize requests from all apps. You'll probably like this.
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize"
})
suppressMaximizeRule:set_enabled(false)

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true
})


hl.window_rule({
    match = {
        class = "blender",
    },
    float = true,
    size = { 1600, 1000 }
})

hl.window_rule({
    match = {
        class = "anki",
    },
    size = { 800, 600 }
})

hl.window_rule({
    match = {
        class = "dolphin",
    },
    float = true,
    size = { 800, 600 }
})
