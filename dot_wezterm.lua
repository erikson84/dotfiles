-- Pull in the wezterm API
local wezterm = require("wezterm")
-- local mux = wezterm.mux


-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = "Catppuccin Mocha"
config.default_prog = { "pwsh" }
config.font = wezterm.font("VictorMono Nerd Font", { weight = "Regular" })
config.font_size = 13
config.font_rules = {
  {
    intensity = 'Bold',
    italic = true,
    font = wezterm.font {
      family = 'VictorMono Nerd Font',
      weight = 'Bold',
      style = 'Italic',
    },
  },
  {
    italic = true,
    intensity = 'Half',
    font = wezterm.font {
      family = 'VictorMono Nerd Font',
      weight = 'DemiBold',
      style = 'Italic',
    },
  },
  {
    italic = true,
    intensity = 'Normal',
    font = wezterm.font {
      family = 'VictorMono Nerd Font',
      style = 'Italic',
    },
  },
}
config.animation_fps = 20
config.window_decorations = "RESIZE"
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
-- config.initial_cols = 213
-- config.initial_rows = 42
-- config.strikethrough_position = 17
config.leader = { key = 'Space', mods = 'CTRL', timeout_milliseconds = 1000 }
config.default_cursor_style = 'BlinkingBlock'
config.custom_block_glyphs = false
-- wezterm.on('gui-startup', function(cmd)
--   local tab, pane, window = mux.spawn_window(cmd or {})
--   window:gui_window():maximize()
-- end)

config.keys = {
  {
    key = '|',
    mods = 'LEADER|SHIFT',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = '+',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
    mods = 'LEADER|SHIFT',
  },
  {
    key = 't',
    mods = 'LEADER',
    action = wezterm.action.SpawnTab 'CurrentPaneDomain'
  }
}

for i = 1, 9 do
  table.insert(config.keys, {
    key = tostring(i),
    mods = 'LEADER',
    action = wezterm.action.ActivateTab(i - 1)
  })
end

local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")
tabline.setup({
  options = {
    icons_enabled = true,
    theme = 'Catppuccin Mocha',
    tabs_enabled = true,
    theme_overrides = {},
    section_separators = {
      left = wezterm.nerdfonts.ple_right_half_circle_thick,
      right = wezterm.nerdfonts.ple_left_half_circle_thick,
    },
    component_separators = {
      left = wezterm.nerdfonts.ple_right_half_circle_thin,
      right = wezterm.nerdfonts.ple_left_half_circle_thin,
    },
    tab_separators = {
      left = wezterm.nerdfonts.ple_right_half_circle_thick,
      right = wezterm.nerdfonts.ple_left_half_circle_thick,
    },
  },
  sections = {
    tabline_a = { 'mode' },
    tabline_b = { 'workspace' },
    tabline_c = { ' ' },
    tab_active = {
      'index',
      { 'parent', padding = 0 },
      '/',
      { 'cwd', padding = { left = 0, right = 1 } },
      { 'zoomed', padding = 0 },
    },
    tab_inactive = { 'index', { 'process', padding = { left = 0, right = 1 } } },
    tabline_x = { 'ram', 'cpu' },
    tabline_y = { 'battery' },
    tabline_z = { { 'datetime', style = "%H:%M %d/%m/%y" } },
  },
  extensions = {},
})
tabline.apply_to_config(config)

config.window_padding = {
  left = 5,
  right = 5,
  top = 0,
  bottom = 0
}
config.front_end = "WebGpu"
config.max_fps = 240
return config
