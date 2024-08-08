return {
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'zbirenbaum/copilot-cmp',
            'onsails/lspkind.nvim',
        },
        opts = function()
            local cmp = require('cmp')
            local lspkind = require('lspkind')

            return {
                snippet = {
                    expand = function(args)
                        vim.snippet.expand(args.body)
                    end,
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                }),
                sources = cmp.config.sources({
                    { name = 'copilot',  group_index = 2 },
                    { name = 'nvim_lsp', group_index = 2 },
                }),
                formatting = {
                    format = lspkind.cmp_format {
                        mode = 'symbol',
                        max_width = 50,
                        symbol_map = { Copilot = '' },
                    },
                },
            }
        end,
        config = function(_, opts)
            local has_copilot, _ = pcall(require, 'copilot')
            if has_copilot then
                require('copilot_cmp').setup()
            end

            require('cmp').setup(opts)
        end
    },
}
