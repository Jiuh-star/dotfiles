-- ============================================================================
-- WezTerm Configuration
-- ============================================================================
---@type Wezterm
local wezterm = require "wezterm"

---@type Config
local config = wezterm.config_builder()

local workspace_picker = wezterm.plugin.require "https://github.com/isseii10/workspace-picker.wezterm"
workspace_picker.apply_to_config(config, {})

-- ============================================================================
-- 1. Modules & Libraries
-- ============================================================================
local platform = require "utils.platform"
local gpu_adapters = require "utils.gpu-adapter"

-- local nf = wezterm.nerdfonts

-- ============================================================================
-- 2. General Configuration
-- ============================================================================
config.max_fps = 120
config.front_end = "WebGpu"
config.webgpu_power_preference = "LowPower"
config.webgpu_preferred_adapter = gpu_adapters:pick_best()
-- config.underline_thickness = "1.2pt"

config.animation_fps = 60
config.cursor_blink_ease_in = "EaseOut"
config.cursor_blink_ease_out = "EaseOut"
config.default_cursor_style = "BlinkingBlock"
config.cursor_blink_rate = 650

-- Appearance
config.color_scheme = "Catppuccin Mocha"
config.window_background_opacity = platform.is_mac and 1 or 0.75

config.enable_scroll_bar = false
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.use_fancy_tab_bar = false
config.tab_max_width = 23
-- config.show_tab_index_in_tab_bar = false
config.switch_to_last_active_tab_when_closing_tab = true

config.window_padding = { left = 5, right = 5, top = 5, bottom = 5 }
config.adjust_window_size_when_changing_font_size = false
-- config.window_close_confirmation = "NeverPrompt"
config.window_frame = { active_titlebar_bg = "#090909" }
config.inactive_pane_hsb = { saturation = 1, brightness = 1 }

config.visual_bell = {
  fade_in_function = "EaseIn",
  fade_in_duration_ms = 250,
  fade_out_function = "EaseOut",
  fade_out_duration_ms = 250,
  target = "CursorColor",
}

config.font = wezterm.font_with_fallback {
  { family = "CaskaydiaMono NFP", harfbuzz_features = { "calt", "ss01" } },
  "NotoColorEmoji",
  "Sarasa Fixed SC",
}
config.font_size = 12

-- Behaviors
config.automatically_reload_config = true
config.exit_behavior = "CloseOnCleanExit"
config.exit_behavior_messaging = "Verbose"
config.status_update_interval = 1000
config.audible_bell = "Disabled"
config.scrollback_lines = 20000

config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- ============================================================================
-- 3. Domains & Shells
-- ============================================================================
local launch_menu = {}
local wsl_domains = {}
local unix_domains = {}

if platform.is_win then
  config.default_prog = { "nu", "-l" }
  launch_menu = {
    { label = "Nushell",            args = { "nu", "-l" } },
    { label = "PowerShell Core",    args = { "pwsh", "-NoLogo" } },
    { label = "PowerShell Desktop", args = { "powershell" } },
    { label = "Command Prompt",     args = { "cmd" } },
    { label = "Msys2",              args = { "ucrt64.cmd" } },
    { label = "Bash",               args = { "bash.exe", "-l" } },
  }
  wsl_domains = {}
elseif platform.is_linux then
  config.default_prog = { "nu", "-l" }
  launch_menu = {
    { label = "Nushell", args = { "nu", "-l" } },
    { label = "Bash",    args = { "bash", "-l" } },
    { label = "Zsh",     args = { "zsh", "-l" } },
  }
elseif platform.is_mac then
  config.default_prog = { "zsh", "-l" }
  launch_menu = {
    { label = "Nushell", args = { "zsh", "-l", "-c", "nu -l" } },
    { label = "Bash",    args = { "bash", "-l" } },
    { label = "Zsh",     args = { "zsh", "-l" } },
  }
end

config.launch_menu = launch_menu
config.wsl_domains = wsl_domains
config.unix_domains = unix_domains

local smart_ssh = wezterm.plugin.require "https://github.com/DavidRR-F/smart_ssh.wezterm"
smart_ssh.apply_to_config(config, {})

-- ============================================================================
-- 4. Key Bindings
-- ============================================================================
-- local mod = {}
-- if platform.is_mac then
--   mod.SUPER = "SUPER"
--   mod.SUPER_REV = "SUPER|CTRL"
-- elseif platform.is_win or platform.is_linux then
--   mod.SUPER = "ALT"
--   mod.SUPER_REV = "ALT|CTRL"
-- end
--
-- config.disable_default_key_bindings = true
-- config.leader = { key = "a", mods = mod.SUPER_REV }

-- config.keys = {
--   { key = "F1", mods = "NONE", action = act.ActivateCopyMode },
--   { key = "F2", mods = "NONE", action = act.ActivateCommandPalette },
--   { key = "F3", mods = "NONE", action = act.ShowLauncher },
--   { key = "F4", mods = "NONE", action = act.ShowLauncherArgs { flags = "FUZZY|TABS" } },
--   { key = "F5", mods = "NONE", action = act.ShowLauncherArgs { flags = "FUZZY|WORKSPACES" } },
--   { key = "F11", mods = "NONE", action = act.ToggleFullScreen },
--   { key = "F12", mods = "NONE", action = act.ShowDebugOverlay },
--   { key = "f", mods = mod.SUPER, action = act.Search { CaseInSensitiveString = "" } },
--   {
--     key = "u",
--     mods = mod.SUPER_REV,
--     action = act.QuickSelectArgs {
--       label = "open url",
--       patterns = {
--         "\\((https?://\\S+)\\)",
--         "\\[(https?://\\S+)\\]",
--         "\\{(https?://\\S+)\\}",
--         "<(https?://\\S+)>",
--         "\\bhttps?://\\S+[)/a-zA-Z0-9-]+",
--       },
--       action = wezterm.action_callback(function(window, pane)
--         local url = window:get_selection_text_for_pane(pane)
--         wezterm.open_with(url)
--       end),
--     },
--   },
--
--   { key = "LeftArrow", mods = mod.SUPER, action = act.SendString "\x1bOH" },
--   { key = "RightArrow", mods = mod.SUPER, action = act.SendString "\x1bOF" },
--   { key = "Backspace", mods = mod.SUPER, action = act.SendString "\x15" },
--
--   { key = "c", mods = "CTRL|SHIFT", action = act.CopyTo "Clipboard" },
--   { key = "v", mods = "CTRL|SHIFT", action = act.PasteFrom "Clipboard" },
--   { key = "n", mods = "CTRL|SHIFT", action = act.SendString "\x2660" },
--   { key = "s", mods = "CTRL|SHIFT", action = act.SendString "\x203D" },
--
--   { key = "t", mods = mod.SUPER, action = act.SpawnTab "DefaultDomain" },
--   { key = "t", mods = mod.SUPER_REV, action = act.SpawnTab { DomainName = "wsl:ubuntu-fish" } },
--   { key = "w", mods = mod.SUPER_REV, action = act.CloseCurrentTab { confirm = false } },
--
--   { key = "[", mods = mod.SUPER, action = act.ActivateTabRelative(-1) },
--   { key = "]", mods = mod.SUPER, action = act.ActivateTabRelative(1) },
--   { key = "[", mods = mod.SUPER_REV, action = act.MoveTabRelative(-1) },
--   { key = "]", mods = mod.SUPER_REV, action = act.MoveTabRelative(1) },
--
--   { key = "0", mods = mod.SUPER, action = act.EmitEvent "tabs.manual-update-tab-title" },
--   { key = "0", mods = mod.SUPER_REV, action = act.EmitEvent "tabs.reset-tab-title" },
--   { key = "9", mods = mod.SUPER, action = act.EmitEvent "tabs.toggle-tab-bar" },
--
--   { key = "n", mods = mod.SUPER, action = act.SpawnWindow },
--   {
--     key = "-",
--     mods = mod.SUPER,
--     action = wezterm.action_callback(function(window, _)
--       local dimensions = window:get_dimensions()
--       if platform.is_win or dimensions.is_full_screen then
--         return
--       end
--       window:set_inner_size(dimensions.pixel_width - 50, dimensions.pixel_height - 50)
--     end),
--   },
--   {
--
--     mods = mod.SUPER,
--     action = wezterm.action_callback(function(window, _)
--       local dimensions = window:get_dimensions()
--       if platform.is_win or dimensions.is_full_screen then
--         return
--       end
--       window:set_inner_size(dimensions.pixel_width + 50, dimensions.pixel_height + 50)
--     end),
--   },
--   {
--     key = "Enter",
--     mods = mod.SUPER_REV,
--     action = wezterm.action_callback(function(window, _)
--       window:maximize()
--     end),
--   },
--
--   { key = "\\", mods = mod.SUPER, action = act.SplitVertical { domain = "CurrentPaneDomain" } },
--   { key = "\\", mods = mod.SUPER_REV, action = act.SplitHorizontal { domain = "CurrentPaneDomain" } },
--
--   { key = "Enter", mods = mod.SUPER, action = act.TogglePaneZoomState },
--   { key = "w", mods = mod.SUPER, action = act.CloseCurrentPane { confirm = false } },
--
--   { key = "k", mods = mod.SUPER_REV, action = act.ActivatePaneDirection "Up" },
--   { key = "j", mods = mod.SUPER_REV, action = act.ActivatePaneDirection "Down" },
--   { key = "h", mods = mod.SUPER_REV, action = act.ActivatePaneDirection "Left" },
--   { key = "l", mods = mod.SUPER_REV, action = act.ActivatePaneDirection "Right" },
--   {
--     key = "p",
--     mods = mod.SUPER_REV,
--     action = act.PaneSelect { alphabet = "1234567890", mode = "SwapWithActiveKeepFocus" },
--   },
--
--   { key = "u", mods = mod.SUPER, action = act.ScrollByLine(-5) },
--   { key = "d", mods = mod.SUPER, action = act.ScrollByLine(5) },
--   { key = "PageUp", mods = "NONE", action = act.ScrollByPage(-0.75) },
--   { key = "PageDown", mods = "NONE", action = act.ScrollByPage(0.75) },
--
--   {
--     key = "f",
--     mods = "LEADER",
--     action = act.ActivateKeyTable { name = "resize_font", one_shot = false, timeout_milliseconds = 1000 },
--   },
--   {
--     key = "p",
--     mods = "LEADER",
--     action = act.ActivateKeyTable { name = "resize_pane", one_shot = false, timeout_milliseconds = 1000 },
--   },
-- }
--
-- config.key_tables = {
--   resize_font = {
--     { key = "k", action = act.IncreaseFontSize },
--     { key = "j", action = act.DecreaseFontSize },
--     { key = "r", action = act.ResetFontSize },
--     { key = "Escape", action = "PopKeyTable" },
--     { key = "q", action = "PopKeyTable" },
--   },
--   resize_pane = {
--     { key = "k", action = act.AdjustPaneSize { "Up", 1 } },
--     { key = "j", action = act.AdjustPaneSize { "Down", 1 } },
--     { key = "h", action = act.AdjustPaneSize { "Left", 1 } },
--     { key = "l", action = act.AdjustPaneSize { "Right", 1 } },
--     { key = "Escape", action = "PopKeyTable" },
--     { key = "q", action = "PopKeyTable" },
--   },
-- }
--
-- config.mouse_bindings = {
--   { event = { Up = { streak = 1, button = "Left" } }, mods = "CTRL", action = act.OpenLinkAtMouseCursor },
-- }

-- ============================================================================
-- 5. Events: UI, Status & Tab Bar
--    Elegantly using the window's resolved color_scheme palette!
-- ============================================================================

-- GUI Startup
local bar = wezterm.plugin.require "https://github.com/adriankarlen/bar.wezterm"
bar.apply_to_config(config, {
  position = platform.is_mac and "bottom" or "top",
  separator = {
    left_icon = wezterm.nerdfonts.fa_long_arrow_right,
  },
  modules = {
    ssh = {
      enabled = true,
    },
  },
  padding = {
    left = 1,
    right = 1,
  }
})

return config
