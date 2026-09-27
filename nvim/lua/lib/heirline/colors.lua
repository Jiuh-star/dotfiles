local M = {}

local utils = require("heirline.utils")

M.setup_colors = function()
  return {
    base = utils.get_highlight("Tabline").bg,
    text = utils.get_highlight("StatusLine").fg,
    subtext = utils.get_highlight("StatusLineNC").fg,
    red = utils.get_highlight("DiagnosticError").fg,
    green = utils.get_highlight("String").fg,
    blue = utils.get_highlight("Function").fg,
    yellow = utils.get_highlight("healthWarning").fg,
    gray = utils.get_highlight("Comment").fg,
    orange = utils.get_highlight("Constant").fg,
    purple = utils.get_highlight("Statement").fg,
    pink = utils.get_highlight("Special").fg,
  }
end

return M
