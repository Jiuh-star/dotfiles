local M = {
  groups = {
    git = "<leader>g",
    ui = "<leader>u",
    language = "<leader>l",
  },
  git = {
    blame_line = "<leader>gb",
    lazygit = "<leader>gl",
    hunk_inline = "<leader>gh",
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
    scroll = "<leader>us"
  },
  language = {
    format = "<leader>lf",
  }
}

vim.g.keymaps = M

return M
