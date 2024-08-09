return {
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            'mason.nvim',
            'williamboman/mason-lspconfig.nvim',
        },
    },
    {
        'williamboman/mason-lspconfig.nvim',
        opts = {
            ensure_installed = { 'lua_ls', 'rust_analyzer', 'ruff', 'basedpyright' },
            automatic_installation = true,
        },
        config = function(_, opts)
            local has_cmp, cmp_lsp = pcall(require, 'cmp_nvim_lsp')
            local lspconfig = require('lspconfig')

            local border = 'rounded'

            -- setup bordered window for lsp floating window.
            require('lspconfig.ui.windows').default_options.border = border

            vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
                vim.lsp.handlers.hover,
                { border = border }
            )
            vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
                vim.lsp.handlers.signature_help,
                { border = border }
            )
            vim.diagnostic.config { float = { border = border } }

            local capabilities = vim.tbl_deep_extend(
                'force',
                {},
                vim.lsp.protocol.make_client_capabilities(),
                has_cmp and cmp_lsp.default_capabilities() or {}
            )

            local handlers = {
                function(server)
                    lspconfig[server].setup {
                        capabilities = capabilities,
                    }
                end,
                ['basedpyright'] = function()
                    lspconfig.pyright.setup {
                        settings = {
                            pyright = {  disableOrganizeImports = true },
                        },
                        python = {
                            analysis = {
                                ignore = { '*' },
                            },
                        },
                    }
                end
            }

            local mlsp = require('mason-lspconfig')

            mlsp.setup(opts)
            mlsp.setup_handlers(handlers)
        end
    }
}
