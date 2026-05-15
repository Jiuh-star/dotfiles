return {
  -- tabline
  {
    "akinsho/bufferline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    opts = {
      ---@type bufferline.Options
      options = {
        indicator = { style = "icon" },
        diagnostics = "nvim_lsp",
        auto_toggle_bufferline = true,
        always_show_bufferline = false,
      },
    },
  },

  -- icons
  {
    "echasnovski/mini.icons",
    lazy = true,
    specs = {
      { "nvim-tree/nvim-web-devicons", enabled = false, optional = true },
    },
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },

  -- statusline
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

  -- colorscheme
  {
    "catppuccin/nvim",
    lazy = false,
    name = "catppuccin",
    priority = 1000,
    ---@type CatppuccinOptions
    opts = {
      transparent_background = false,
      float = {
        transparent = false,
        solid = false,
      },
      term_colors = true,
      auto_integrations = true,
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)

      vim.cmd.colorscheme("catppuccin")
    end,
  },

  -- better UI widget
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      cmdline = {
        view = "cmdline",
      },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
  },

  -- render TODO / FIXME comments
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "VeryLazy",
    opts = {},
  },

  -- dropbar
  {
    "Bekaboo/dropbar.nvim",
    event = "VeryLazy",
    opts = {},
  },
}
