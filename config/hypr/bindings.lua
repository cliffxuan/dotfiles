-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Change an existing binding by unbinding it first, then binding the key again.
-- This example changes SUPER+SPACE from the launcher to the Omarchy root menu.
-- hl.unbind("SUPER + SPACE")
-- o.bind("SUPER + SPACE", "Omarchy menu", "omarchy-menu toggle root")

-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Screenshot directly to clipboard:
-- Replaces default Google Maps shortcut on Super+Shift+S (Cmd+Shift+S on MacBook).
-- 'smart' mode lets you drag to select a region or click to capture a window.
hl.unbind("SUPER + SHIFT + S")
o.bind("SUPER + SHIFT + S", "Screenshot selection to clipboard", "omarchy-capture-screenshot smart copy")
o.bind("SUPER + CTRL + SHIFT + S", "Fullscreen screenshot to clipboard", "omarchy-capture-screenshot fullscreen copy")

-- macOS muscle memory (Cmd + Ctrl + Shift + 4 on MacBook)
o.bind("SUPER + CTRL + SHIFT + 4", "Screenshot selection to clipboard (Mac style)", "omarchy-capture-screenshot smart copy")

-- Reassign Google Maps to Super + Shift + M (replaces default Spotify/Music shortcut)
hl.unbind("SUPER + SHIFT + M")
o.bind("SUPER + SHIFT + M", "Google Maps", { webapp = "https://maps.google.com/", focus = true })

