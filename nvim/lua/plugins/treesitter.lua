return {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    version = false,
    event = { 'VeryLazy' },
    lazy = vim.fn.argc(-1) == 0,
    init = function(plugin)
        require('lazy.core.loader').add_to_rtp(plugin)
        require('nvim-treesitter.query_predicates')
    end,
    cmd = { 'TSUpdateSync', 'TSUpdate', 'TSInstall' },
    ---@type TSConfig
    ---@diagnostic disable-next-line: missing-fields
    opts = {
        highlight = { enable = true },
        indent = { enable = true },
        ensure_installed = {
            'bash',
            'c',
            'diff',
            'html',
            'javascript',
            'jsdoc',
            'json',
            'jsonc',
            'lua',
            'luadoc',
            'luap',
            'markdown',
            'markdown_inline',
            'printf',
            'python',
            'sql',
            'query',
            'regex',
            'toml',
            'tsx',
            'typescript',
            'vim',
            'vimdoc',
            'xml',
            'yaml',
        },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = '<C-space>',
                node_incremental = '<C-space>',
                scope_incremental = false,
                node_decremental = '<bs>',
            },
        },
    },
    ---@param opts TSConfig
    config = function(_, opts)
        require('nvim-treesitter.configs').setup(opts)
    end,
}
