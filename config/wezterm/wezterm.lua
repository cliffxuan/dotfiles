local wezterm = require 'wezterm';

return {
  font = wezterm.font("MesloLGS NF"),
  use_fancy_tab_bar = true,
  enable_tab_bar = true,
  hide_tab_bar_if_only_one_tab = true,
  keys = {
    -- find SendString use `xxd`, pressing the relevant key, then enter, then CTRL-D
    {key="LeftArrow", mods="SUPER", action=wezterm.action{SendString="\x02\x70"}}, -- ctrl-b p
    {key="RightArrow", mods="SUPER", action=wezterm.action{SendString="\x02\x6e"}}, -- ctrl-b n
    {key="d", mods="SUPER", action=wezterm.action{SendString="\x02\x25"}}, -- ctrl-b %
    {key="d", mods="SUPER|SHIFT", action=wezterm.action{SendString="\x02\x22"}}, -- ctrl-b "
    {key="LeftArrow", mods="SUPER|SHIFT", action=wezterm.action{SendString="\x02\x48"}}, -- ctrl-b H
    {key="RightArrow", mods="SUPER|SHIFT", action=wezterm.action{SendString="\x02\x4c"}}, -- ctrl-b L
    {key="UpArrow", mods="SUPER|SHIFT", action=wezterm.action{SendString="\x02\x4b"}}, -- ctrl-b K
    {key="DownArrow", mods="SUPER|SHIFT", action=wezterm.action{SendString="\x02\x4a"}}, -- ctrl-b J
    {key="n", mods="SUPER|SHIFT", action=wezterm.action{SendString="\x02\x63"}}, -- ctrl-b c
    {key="w", mods="SUPER|SHIFT", action=wezterm.action{SendString="\x02\x78"}}, -- ctrl-b x
    {key="x", mods="SUPER", action=wezterm.action{SendString="\x02\x5b"}}, -- ctrl-b [
    {key = "f", mods = 'SHIFT|CTRL', action = wezterm.action.ToggleFullScreen}, -- ? how to use fn key
  },
  window_padding = {
    left = 10,
    right = 10,
    top = 0,
    bottom = 0,
  },
  -- color_scheme = "ayu",
  -- color_scheme = "DotGov",
  -- color_scheme = "Dracula",
}
