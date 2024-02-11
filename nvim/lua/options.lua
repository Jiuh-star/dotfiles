local opt = vim.opt

-- interface
opt.cursorline = true
opt.fillchars = { vert = "|" }
opt.laststatus = 3
opt.number = true
opt.relativenumber = true
opt.scrolloff = 8
-- opt.shortmess:append("c")
opt.sidescrolloff = 8
opt.signcolumn = "yes"
opt.splitbelow = true
opt.splitright = true
opt.termguicolors = true
opt.title = true
opt.showmode = false

-- indentation
opt.expandtab = true
opt.softtabstop = 4
opt.shiftwidth = 4

-- search
opt.ignorecase = true
opt.smartcase = true

-- completion
opt.completeopt = { "menu", "noselect" }
opt.pumheight = 10

-- behavior
opt.clipboard = "unnamedplus"
opt.hidden = true
opt.undofile = true
opt.updatetime = 1000


vim.g.mapleader = " "

