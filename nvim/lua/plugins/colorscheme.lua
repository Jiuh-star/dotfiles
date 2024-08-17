return {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = false,
    priority = 1000,
    opts = {
        transparent_background = true,
        integrations = {
            barbecue = {},
            gitsigns = true,
            mason = true,
            cmp = true,
            native_lsp = { enabled = true },
            navic = { enabled = true },
            treesitter = true,
        }
    },
    config = function(_, opts)
        require('catppuccin').setup(opts)
        vim.cmd([[colorscheme catppuccin]])
    end,
}
