local M = {
  groups = {
    git = "<leader>g",
    ui = "<leader>u",
  },
  git = {
    blame_line = "<leader>gb",
  },
  ui = {
    dim = "<leader>uD",
    indent = "<leader>ui",
    inlay_hints = "<leader>uh",
    treesitter = "<leader>ut",
    diagnostics = "<leader>ud",
    line_number = "<leader>ul",
    background = "<leader>ub",
    wrap = "<leader>uw",
  },
}

vim.g.keymaps = M

return M
