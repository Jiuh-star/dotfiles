return {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
        ---@type false | "classic" | "modern" | "helix"
        preset = "modern",
        ---@param mapping wk.Mapping
        filter = function(mapping)
            return mapping.desc and mapping.desc ~= ""
        end
    },
    keys = {
        {
            '<leader>?',
            function()
                require('which-key').show({ global = false })
            end,
            desc = 'Buffer Local Keymaps (which-key)',
        },
    }
}
