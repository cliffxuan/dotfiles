local wezterm = require 'wezterm';

return {
  font = wezterm.font("MesloLGS NF"),
  use_fancy_tab_bar = true,
  enable_tab_bar = true,
  hide_tab_bar_if_only_one_tab = true,
  keys = {
    {key="LeftArrow", mods="SUPER", action=wezterm.action{SendString="\x00\x70"}}, -- ctrl-space p
    {key="RightArrow", mods="SUPER", action=wezterm.action{SendString="\x00\x6e"}}, -- ctrl-space n
    {key="LeftArrow", mods="SUPER|SHIFT", action=wezterm.action{SendString="\x00\x68"}}, -- ctrl-space h
    {key="RightArrow", mods="SUPER|SHIFT", action=wezterm.action{SendString="\x00\x6c"}}, -- ctrl-space l
    {key="UpArrow", mods="SUPER|SHIFT", action=wezterm.action{SendString="\x00\x6b"}}, -- ctrl-space k
    {key="DownArrow", mods="SUPER|SHIFT", action=wezterm.action{SendString="\x00\x6a"}}, -- ctrl-space j
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
  color_scheme = "Dracula",
}
