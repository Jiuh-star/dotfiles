-- material
-- return {
--     "marko-cerovac/material.nvim",
--     config = function(_, opts)
--         require("material").setup(opts)
--         require("material.functions").change_style("palenight")
--     end,
--     opts = {
--         plugins = {
--             "illuminate",
--             "nvim-cmp",
--             "nvim-web-devicons",
--         },
--         disable = {
--             background = true,
--         }
--     }
-- }

-- catppuccin
return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function(_, opts)
        require("catppuccin").setup(opts)
        vim.cmd.colorscheme "catppuccin"
    end,
    opts = {
        transparent_background = true,
        show_end_of_buffer = true,
        integrations = {
            notify = true,
            mason = true,
            cmp = true,
        }
    }
}

