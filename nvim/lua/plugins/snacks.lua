return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      quickfile = { enabled = false },  -- it load treesitter too early.
      animate = { enabled = true },
      scroll = { enabled = true },
      indent = {
        enabled = true,
        chunk = {
          enabled = true,
          char = { corner_top = "╭", corner_bottom = "╰", arrow = "" }
        }
      },
      dim = { enabled = true },
      gitbrowse = { enabled = true },
    },
    config = function(_, opts)
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          local toggle = Snacks.toggle
          local keymaps = vim.g.keymaps.ui

          toggle.dim():map(keymaps.dim)
          toggle.indent():map(keymaps.indent)
          toggle.inlay_hints():map(keymaps.inlay_hints)
          toggle.treesitter():map(keymaps.treesitter)
          toggle.diagnostics():map(keymaps.diagnostics)
          toggle.line_number():map(keymaps.line_number)
          toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map(keymaps.background)
          toggle.option("wrap", { name = "Wrap line" }):map(keymaps.wrap)
        end
      })


      require("snacks").setup(opts)
    end,
  }
}
