local M = {}

local utils = require("heirline.utils")
local colors = require("lib.heirline.colors")
local components = require("lib.heirline.components")

M.setup = function(opts)
  -- (string) opts.statusline -> (table) actual statusline
  local statusline = utils.clone(components.global)
  for i, name in ipairs(opts.statusline) do
    if i ~= 0 then table.insert(statusline, components.space) end

    local component = components[name]
    if component then table.insert(statusline, component) end
  end
  opts.statusline = statusline
  opts.opts = { colors = colors.setup_colors() }

  require("heirline").setup(opts)

  vim.api.nvim_create_augroup("Heirline", { clear = true })
  vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function() utils.on_colorscheme(colors.setup_colors) end,
    group = "Heirline",
  })
end

return M
