if vim.loader then vim.loader.enable() end

--- Pretty print objects with `snacks.debug.inspect`
_G.dd = function(...) require("snacks.debug").inspect(...) end
--- Print stack trace with `snacks.debug.backtrace`
_G.bt = function(...) require("snacks.debug").backtrace(...) end
--- Profile function execution time with `snacks.debug.profile`
_G.p = function(...) require("snacks.debug").profile(...) end
---@diagnostic disable-next-line: duplicate-set-field
vim._print = function(_, ...) dd(...) end

require("config.options")
require("config.keymaps")
require("config.autocmds")

require("config.lazy").load {
  debug = false,
  profiling = {
    loader = false,
    require = false,
  },
}

require("config.neovide")
