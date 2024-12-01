-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {
  base46 = {
    theme = "catppuccin",
    transparency = true,
    theme_toggle = { "catppuccin", "github_light" }
  },
  ui = {
    statusline = {
      theme = "minimal",
      separator_style = "round",
    },
    cmp = {
      icons_left = true,
      style = "default",
      format_colors = {
        tailwind = true,
      }
    }
  },
  nvdash = {
    load_on_startup = true
  }
}

return M
