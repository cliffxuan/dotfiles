local wezterm = require 'wezterm';

return {
  font = wezterm.font("MesloLGS NF"),
  use_fancy_tab_bar = true,
  enable_tab_bar = true,
  hide_tab_bar_if_only_one_tab = true,
  keys = {
    {key="LeftArrow", mods="SUPER", action=wezterm.action{SendString="\x00\x70"}}, -- ctrl-space p
    {key="RightArrow", mods="SUPER", action=wezterm.action{SendString="\x00\x6e"}}, -- ctrl-space n
    {key="d", mods="SUPER", action=wezterm.action{SendString="\x00\x25"}}, -- ctrl-space %
    {key="d", mods="SUPER|SHIFT", action=wezterm.action{SendString="\x00\x22"}}, -- ctrl-space "
    {key="LeftArrow", mods="SUPER|SHIFT", action=wezterm.action{SendString="\x00\x48"}}, -- ctrl-space H
    {key="RightArrow", mods="SUPER|SHIFT", action=wezterm.action{SendString="\x00\x4c"}}, -- ctrl-space L
    {key="UpArrow", mods="SUPER|SHIFT", action=wezterm.action{SendString="\x00\x4b"}}, -- ctrl-space K
    {key="DownArrow", mods="SUPER|SHIFT", action=wezterm.action{SendString="\x00\x4a"}}, -- ctrl-space J
    {key="x", mods="SUPER", action=wezterm.action{SendString="\x00\x5b"}}, -- ctrl-space [
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
