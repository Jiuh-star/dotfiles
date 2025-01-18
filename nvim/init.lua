if vim.loader then
  vim.loader.enable()
end

_G.dd = function(...)
  require("snacks.debug").inspect(...)
end
_G.bt = function()
  require("snacks.debug").backtrace()
end
_G.p = function(...)
  require("snacks.debug").profile(...)
end
vim.print = _G.dd

require("config.options")
require("config.keymaps")
require("config.autocmds")

require("config.lazy").load({
  debug = false,
  profiling = {
    loader = false,
    require = false,
  },
})
