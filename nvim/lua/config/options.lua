local opt = vim.opt

-- | interface |
-- display a highlighted line on the cursor
opt.cursorline = true
-- display the number on the statuscolumn
opt.number = true
-- use relative number w.r.t. the cursor instead of the absolute number from the file start.
opt.relativenumber = true
-- keep the cursor in the middle of the screen
opt.scrolloff = 8
-- keep the cursor in the middle of the screen when scrolling
opt.sidescrolloff = 8
-- display the line number on the statuscolumn
opt.signcolumn = 'yes'
-- split the window below and right
opt.splitbelow = true
opt.splitright = true
-- for true color terminal
opt.termguicolors = true
-- display title in the window titlebar
opt.title = true
-- only display one status line
opt.laststatus = 3

-- | indentation |
opt.expandtab = true
opt.softtabstop = 4
opt.shiftwidth = 4

-- | search |
opt.completeopt = { 'menu', 'noselect' }
opt.pumheight = 10

-- | behavior |
opt.clipboard = 'unnamedplus'
opt.hidden = false
opt.undofile = true
opt.updatetime = 4000

vim.g.loaded_python3_provider = 0
