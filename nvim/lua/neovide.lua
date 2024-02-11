-- safe check
if not vim.g.neovide then
    return
end

-- Put anything you want to happen only in Neovide here
-- font size
vim.o.guifont = "Hack Nerd Font,MicroSoft YaHei:h12"

-- background color (currently only works in macOS)
-- Helper function for transparency formatting
-- local alpha = function()
-- return string.format("%x", math.floor(255 * vim.g.transparency or 0.8))
-- end
-- vim.g.neovide_transparency = 0.0
-- vim.g.transparency = 0.8
-- vim.g.neovide_background_color = "#0f1117" .. alpha()

-- floating window blur amount
vim.g.neovide_floating_blur_amount_x = 2.0
vim.g.neovide_floating_blur_amount_y = 2.0

-- transparaency
vim.g.neovide_transparency = 0.8

-- scroll animation length
vim.g.neovide_scroll_animation_length = 0.3

-- hiding the mouse cursor when typing
vim.g.neovide_hide_mouse_when_typing = false

-- refresh rate
vim.g.neovide_refresh_rate = 60

-- idle refresh rate
vim.g.neovide_refresh_rate_idle = 5

-- no idle
vim.g.neovide_no_idle = true

-- confirm quit
vim.g.neovide_confirm_quit = true

-- fullscreen
vim.g.neovide_fullscreen = true

-- remember previous window size
vim.g.neovide_remember_window_size = true

-- profiler
vim.g.neovide_profiler = false

-- use logo key
vim.g.neovide_input_use_logo = false    -- true on mac

-- mac alt is Meta
vim.g.neovide_input_macos_alt_is_meta = false

-- touch deadzone
vim.g.neovide_touch_deadzone = 6.0

-- touch drag timeout
vim.g.neovide_touch_drag_timeout = 0.5

-- curse animation length
-- vim.g.neovide_cursor_animation_length = 0.13

-- animation trail size
vim.g.neovide_cursor_trail_size = 0.8

-- antialiasing
vim.g.neovide_cursor_antialiasing = true

-- animation in insert mode
vim.g.neovide_cursor_animate_in_insert_mode = true

-- animation switch to command line
vim.g.neovide_cursor_animate_command_line = true

-- unfocused outline width
vim.g.neovide_cursor_unfocused_outline_width = 0.125

-- curse particles
vim.g.neovide_cursor_vfx_mode = "railgun"

-- particle opacity
vim.g.neovide_cursor_vfx_opacity = 200.0

-- particle lifetime
vim.g.neovide_cursor_vfx_particle_lifetime = 1.2

-- particle density
vim.g.neovide_cursor_vfx_particle_density = 7.0

-- particle speed
vim.g.neovide_cursor_vfx_particle_speed = 10.0

-- particle curl
-- vim.g.neovide_cursor_vfx_particle_curl = 1.0

-- floating window
vim.g.neovide_floating_shadow = true
vim.g.neovide_floating_z_height = 10
vim.g.neovide_light_angle_degrees = 45
vim.g.neovide_light_radius = 5

-- IME
vim.g.neovide_input_ime = true

local function set_ime(args)
    if args.event:match("Enter$") then
        vim.g.neovide_input_ime = true
    else
        vim.g.neovide_input_ime = false
    end
end

local ime_input = vim.api.nvim_create_augroup("ime_input", { clear = true })

vim.api.nvim_create_autocmd({ "InsertEnter", "InsertLeave" }, {
    group = ime_input,
    pattern = "*",
    callback = set_ime
})

vim.api.nvim_create_autocmd({ "CmdlineEnter", "CmdlineLeave" }, {
    group = ime_input,
    pattern = "[/\\?]",
    callback = set_ime
})