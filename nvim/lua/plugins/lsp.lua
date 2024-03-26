local M = {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/nvim-cmp",
        "folke/neodev.nvim",
    },
}

local function on_attach(_, _)
    vim.keymap.set("n", "K", vim.lsp.buf.hover)
end

function M.config(_, opts)
    require("mason").setup {}
    require("mason-lspconfig").setup {
        ensure_installed = { "lua_ls" },
    }

    require("neodev").setup {}

    local lspconfig = require("lspconfig")
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    lspconfig.lua_ls.setup {
        capabilities = capabilities,
        on_attach = on_attach,
    }
end

return M

