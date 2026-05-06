local wezterm = require 'wezterm'
local act = wezterm.action
local config_root = '/Users/byron/Documents/lua/wezterm'
local layouts = dofile(config_root .. '/layouts/init.lua')

local config = wezterm.config_builder()

-- Window
config.initial_cols = 80
config.initial_rows = 25
config.window_decorations = 'RESIZE'
config.window_padding = {
  left = 10,
  right = 10,
  top = 8,
  bottom = 8,
}

-- Font
config.font = wezterm.font_with_fallback {
  'Google Sans Code',
  'Monaco',
}
config.font_size = 20
config.line_height = 1.0
config.cell_width = 1.0

-- Colors ported from Default.json iTerm2 profile.
config.colors = {
  foreground = '#bbbbbb',
  background = '#000000',
  cursor_bg = '#bbbbbb',
  cursor_fg = '#ffffff',
  cursor_border = '#bbbbbb',
  selection_bg = '#b5d5ff',
  selection_fg = '#000000',

  ansi = {
    '#000000',
    '#bb0000',
    '#00bb00',
    '#bbbb00',
    '#0000bb',
    '#bb00bb',
    '#00bbbb',
    '#bbbbbb',
  },
  brights = {
    '#555555',
    '#ff5555',
    '#55ff55',
    '#ffff55',
    '#5555ff',
    '#ff55ff',
    '#55ffff',
    '#ffffff',
  },
}
config.window_background_opacity = 1.0
config.macos_window_background_blur = 0

-- Tabs
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false

-- Shell behavior
config.scrollback_lines = 1000
config.audible_bell = 'Disabled'
config.check_for_updates = false

-- Leader key: CTRL+a, then press the following key.
config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }

config.keys = {
  { key = 't', mods = 'CMD', action = act.SpawnTab 'CurrentPaneDomain' },
  { key = 'w', mods = 'CMD', action = act.CloseCurrentTab { confirm = true } },
  { key = 'Enter', mods = 'CMD', action = act.ToggleFullScreen },

  { key = '|', mods = 'LEADER|SHIFT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = '-', mods = 'LEADER', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
  { key = 'x', mods = 'LEADER', action = act.CloseCurrentPane { confirm = true } },
  { key = 'z', mods = 'LEADER', action = act.TogglePaneZoomState },
  { key = 'o', mods = 'CMD', action = layouts.picker_action() },

  { key = 'h', mods = 'LEADER', action = act.ActivatePaneDirection 'Left' },
  { key = 'j', mods = 'LEADER', action = act.ActivatePaneDirection 'Down' },
  { key = 'k', mods = 'LEADER', action = act.ActivatePaneDirection 'Up' },
  { key = 'l', mods = 'LEADER', action = act.ActivatePaneDirection 'Right' },
}

return config
