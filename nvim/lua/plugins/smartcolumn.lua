return {
    'm4xshen/smartcolumn.nvim',
    event = { 'InsertEnter' },
    opts = {
        disabled_filetypes = {
            'help',
            'text',
            'markdown',
            'lazy',
            'mason',
            'help',
            'checkhealth',
            'lspinfo',
            'noice',
        },
        custom_colorcolumn = {
            python = '120',
            lua = '120'
        }
    },
}
