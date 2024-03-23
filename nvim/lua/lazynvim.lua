-- bootstrap lazy.nvim at the first time
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    local ok, _ = pcall(vim.fn.system, {
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })

    if not ok then
        vim.notify("Can not install lazy.nvim due to git not found or network issue.", vim.log.levels.ERROR)
    end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins")
