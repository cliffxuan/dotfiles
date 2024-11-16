local wezterm = require 'wezterm'

local launch_menu = {}
local tmux_mod
local default_prog
if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
  tmux_mod = 'ALT'
  default_prog = { 'wsl.exe' }
  table.insert(launch_menu, {
    label = 'PowerShell',
    args = { 'powershell.exe', '-NoLogo' },
  })
else
  tmux_mod = 'SUPER'
  default_prog = { 'zsh' }
end

local keys = {
  -- find SendString use `xxd`, pressing the relevant key, then enter, then CTRL-D
  { key = 'LeftArrow', mods = tmux_mod, action = wezterm.action { SendString = '\x02\x70' } }, -- ctrl-b p
  { key = 'RightArrow', mods = tmux_mod, action = wezterm.action { SendString = '\x02\x6e' } }, -- ctrl-b n
  { key = 'd', mods = tmux_mod, action = wezterm.action { SendString = '\x02\x25' } }, -- ctrl-b %
  { key = 'd', mods = tmux_mod .. '|SHIFT', action = wezterm.action { SendString = '\x02\x22' } }, -- ctrl-b "
  { key = 'LeftArrow', mods = tmux_mod .. '|SHIFT', action = wezterm.action { SendString = '\x02\x48' } }, -- ctrl-b H
  { key = 'RightArrow', mods = tmux_mod .. '|SHIFT', action = wezterm.action { SendString = '\x02\x4c' } }, -- ctrl-b L
  { key = 'UpArrow', mods = tmux_mod .. '|SHIFT', action = wezterm.action { SendString = '\x02\x4b' } }, -- ctrl-b K
  { key = 'DownArrow', mods = tmux_mod .. '|SHIFT', action = wezterm.action { SendString = '\x02\x4a' } }, -- ctrl-b J
  { key = 'n', mods = tmux_mod .. '|SHIFT', action = wezterm.action { SendString = '\x02\x63' } }, -- ctrl-b c
  { key = 'w', mods = tmux_mod .. '|SHIFT', action = wezterm.action { SendString = '\x02\x78' } }, -- ctrl-b x
  { key = 'x', mods = tmux_mod, action = wezterm.action { SendString = '\x02\x5b' } }, -- ctrl-b [
  { key = 'f', mods = 'SHIFT|CTRL', action = wezterm.action.ToggleFullScreen }, -- ? how to use fn key
}

return {
  -- font = wezterm.font("MesloLGS NF"),
  use_fancy_tab_bar = true,
  enable_tab_bar = true,
  hide_tab_bar_if_only_one_tab = true,
  keys = keys,
  window_padding = {
    left = 10,
    right = 10,
    top = 0,
    bottom = 0,
  },
  launch_menu = launch_menu,
  default_prog = default_prog,
  enable_wayland = true,

  -- color_scheme = "ayu",
  -- color_scheme = "DotGov",
  -- color_scheme = "Dracula",
}
