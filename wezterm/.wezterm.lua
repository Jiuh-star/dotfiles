-- Pull in the wezterm API
local wezterm = require 'wezterm' --[[@as Wezterm]]

-- This will hold the configuration
local config = wezterm.config_builder()

-- UI --
-- Colorscheme of WezTerm, I prefered Catppuccin
config.color_scheme = 'Catppuccin Mocha'
-- Transparent background
config.window_background_opacity = 0.75
-- Fonts
config.font = wezterm.font_with_fallback {
    'Hack Nerd Font',  -- prefered font for development
    'NotoColorEmoji',  -- for emoji
    'Monospace',
    'Sarasa Fixed SC',  -- CJK font
}
config.font_size = 12
-- Default cursor style in interactive shell
config.default_cursor_style = 'BlinkingBlock'
-- Hide window bar but enable window resizing
config.window_decorations = 'RESIZE'
-- Hide tab bar
config.hide_tab_bar_if_only_one_tab = true
-- Fancy tab bar, i.e., render tab bar with terminal font
config.use_fancy_tab_bar = false
-- Platform specific
if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
    config.front_end = "WebGpu"
    config.webgpu_power_preference = "LowPower"
elseif wezterm.target_triple == 'x86_640-unknown-linux-gnu' then
    -- Set cursor, fix for wayland
    local ok, stdout, _ = wezterm.run_child_process({"gsettings", "get", "org.gnome.desktop.interface", "cursor-theme"})
    if ok then
        config.xcursor_theme = stdout:gsub("'(.+)'\n", "%1")
    end

    ok, stdout, _ = wezterm.run_child_process({"gsettings", "get", "org.gnome.desktop.interface", "cursor-size"})
    if ok then
      config.xcursor_size = tonumber(stdout) or 24
    end
end

-- return the configuration to wezterm
return config

