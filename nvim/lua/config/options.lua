local g = vim.g
local o = vim.o
local opt = vim.opt

g.mapleader = " "
g.maplocalleader = "\\"

g.catppuccin_flavour = "mocha" -- mocha, frappe, latte, macchiato

-- Interface
o.cursorline = true
o.laststatus = 3
o.number = true
o.relativenumber = true
o.sidescrolloff = 8
o.scrolloff = 8
o.signcolumn = "yes"
o.splitbelow = true
o.splitright = true
o.termguicolors = true
o.title = true

-- Indentation
o.expandtab = true
o.softtabstop = 4
o.shiftwidth = 4
o.smartindent = false

-- Search
o.ignorecase = true
o.smartcase = true

-- Completion
opt.completeopt = { "menu", "noselect" }
o.pumheight = 10

-- Behavior
o.clipboard = "unnamedplus"
o.hidden = false
o.updatetime = 4000
o.undofile = true
o.backup = true
opt.backupdir = vim.fn.stdpath("state") .. "/backup"
o.mousescroll = "ver:1,hor:6"
o.showmode = false

-- Folding
o.foldmethod = "expr"
o.foldexpr = "nvim_treesitter#foldexpr()"
o.foldcolumn = "0"
o.foldlevel = 99
o.foldlevelstart = 0
o.foldnestmax = 4
opt.fillchars:append({ fold = " " })
require("lib.foldtext").setup()

-- Performance
g.loaded_python3_provider = 0
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0
g.loaded_node_provider = 0
