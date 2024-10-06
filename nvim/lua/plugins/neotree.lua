return {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    cmd = "Neotree",
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-tree/nvim-web-devicons',
        'MunifTanjim/nui.nvim',
        '3rd/image.nvim',
    },
    keys = {
        {
            '<leader>fe',
            function()
                require("neo-tree.command").execute({ toggle = true, dir = require('lazyvim.util').root() })
            end,
            desc = 'Explorer NeoTree (Root Dir)'
        }
    }
}
