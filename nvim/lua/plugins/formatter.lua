return {
    'mhartington/formatter.nvim',
    opts = function()
        return {
            filetype = {
                ['python'] = {
                    require('formatter.filetypes.python').ruff,
                    function()
                        return {
                            exe = 'ruff',
                            args = {
                                'check',
                                '--select',
                                'I',
                                '--fix',
                                '-',
                            },
                            stdin = true
                        }
                    end
                },
                ['*'] = {
                    function()
                        local formatters = require('formatter.util').get_available_formatters_for_ft(vim.bo.filetype)
                        if #formatters > 0 then
                            return
                        end

                        local lsp_clients = vim.lsp.get_clients()
                        for _, client in pairs(lsp_clients) do
                            if client.server_capabilities.documentFormattingProvider then
                                vim.lsp.buf.format {}
                                return
                            end
                        end

                        vim.notify('No available formatter.')
                    end
                }
            }
        }
    end
}
