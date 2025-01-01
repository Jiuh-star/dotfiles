local g = vim.g
local o = vim.o
local opt = vim.opt

g.mapleader = " "
g.maplocalleader = "\\"

g.catppuccin_flavour = "mocha" -- mocha, frappe, latte, macchiato

-- Interface
opt.cursorline = true
opt.laststatus = 3
opt.number = true
opt.relativenumber = true
opt.sidescrolloff = 8
opt.scrolloff = 8
opt.signcolumn = "yes"
opt.splitbelow = true
opt.splitright = true
opt.termguicolors = true
opt.title = true

-- Indentation
opt.expandtab = true
opt.softtabstop = 4
opt.shiftwidth = 4
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true

-- Completion
opt.completeopt = { "menu", "noselect" }
opt.pumheight = 10

-- Behavior
opt.clipboard = "unnamedplus"
opt.hidden = false
opt.updatetime = 4000
opt.undofile = true
opt.backup = true
opt.backupdir = vim.fn.stdpath("state") .. "/backup"
opt.mousescroll = "ver:1,hor:6"

-- Performance
g.loaded_python3_provider = 0
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0
g.loaded_node_provider = 0
