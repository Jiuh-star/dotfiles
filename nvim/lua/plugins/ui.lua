return {
  { "akinsho/bufferline.nvim" },

  {
    "folke/which-key.nvim",
    opts = {
      preset = "helix",
    },
  },

  {
    "echasnovski/mini.icons",
    lazy = true,
    specs = {
      { "nvim-tree/nvim-web-devicons", enabled = false, optional = true },
    },
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },

  {
    "rebelot/heirline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
    event = "VeryLazy",
    opts = {
      statusline = { "mode", "file", "git", "align", "encoding", "diagnostic", "lsp", "cursor" },
    },
    config = function(_, opts)
      local user = require("user.heirline")
      local components = {
        statusline = opts.statusline,
        opts = {
          colors = user.setup_colors(),
        },
      }

      user.setup(components)
    end,
  },

  {
    "catppuccin/nvim",
    lazy = false,
    name = "catppuccin",
    priority = 1000,
    ---@type CatppuccinOptions
    opts = {
      transparent_background = false,
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)

      vim.cmd.colorscheme("catppuccin")
    end,
  },

  -- unintrusive norifications
  {
    "j-hui/fidget.nvim",
    event = "VeryLazy",
    opts = {}
  }
}
