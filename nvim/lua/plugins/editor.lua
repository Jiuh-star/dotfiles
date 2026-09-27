local keys = require("config.keys")

return {
  -- gitsigns
  {
    "lewis6991/gitsigns.nvim",
    lazy = true,
    event = "VeryLazy",
    opts = {},
    config = function(_, opts)
      local gitsigns = require("gitsigns")
      local wk = require("which-key")

      gitsigns.setup(opts)

      Snacks.toggle
        .new({
          id = "gitsigns_blame_line",
          name = "Blame Line",
          get = function() return require("gitsigns.config").config.current_line_blame end,
          set = function(value) gitsigns.toggle_current_line_blame(value) end,
        })
        :map(keys.git.blame_line)

      wk.add({ keys.git.hunk_inline, gitsigns.preview_hunk_inline, desc = "Hunk Inline", icon = " " })
    end,
  },

  -- keymaps
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    ---@type wk.Opts
    opts = {
      preset = "helix",
      spec = {
        mode = { "n", "v" },
        {
          keys.top.local_keys,
          function() require("which-key").show({ global = false }) end,
          desc = "Buffer Local Keymaps",
          icon = " ",
        },
        { keys.groups.ui, group = "UI", icon = { icon = "󰃣 ", color = "cyan" } },
        { keys.groups.find, group = "Find", icon = { icon = "󱁴 ", color = "blue" } },
        { keys.groups.git, group = "Git", icon = { icon = "󰊢 ", color = "orange" } },
        { keys.groups.language, group = "Language", icon = { icon = "󰅨 ", color = "red" } },
        { keys.groups.neovim, group = "NeoVim", icon = { icon = " ", color = "purple" } },
      },
    },
  },

  -- autocompletion
  {
    "saghen/blink.cmp",
    lazy = true,
    event = "VeryLazy",
    version = "*",
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        preset = "super-tab",
      },
      sources = {
        default = { "lazydev", "lsp", "path", "snippets", "buffer" },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100,
          },
        },
      },
      completion = {
        menu = {
          border = "rounded",
          draw = {
            components = {
              kind_icon = {
                ellipsis = false,
                text = function(ctx)
                  local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
                  return kind_icon
                end,
                highlight = function(ctx)
                  local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                  return hl
                end,
              },
            },
          },
        },
        documentation = { window = { border = "rounded" } },
      },
      signature = { enabled = true, window = { border = "rounded" } },
    },
  },

  -- indent detection
  {
    "NMAC427/guess-indent.nvim",
    event = { "VeryLazy", "BufReadPost" },
    opts = {},
  },

  -- fuzzy finder
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    opts = {},
  },

  -- autopairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },

  -- html tag auto close
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    opts = {},
  },
}
