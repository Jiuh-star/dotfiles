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
          local wk = require("which-key")
          local toggle = Snacks.toggle
          local keymaps = vim.g.keymaps

          toggle.dim():map(keymaps.ui.dim)
          toggle.indent():map(keymaps.ui.indent)
          toggle.inlay_hints():map(keymaps.ui.inlay_hints)
          toggle.treesitter():map(keymaps.ui.treesitter)
          toggle.diagnostics():map(keymaps.ui.diagnostics)
          toggle.line_number():map(keymaps.ui.line_number)
          toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map(keymaps.ui.background)
          toggle.option("wrap", { name = "Wrap line" }):map(keymaps.ui.wrap)

          wk.add({ keymaps.git.lazygit, function() Snacks.lazygit() end, desc = "LazyGit", icon = " " })

          vim.api.nvim_create_user_command("LazyGit", function () Snacks.lazygit() end, {})
        end
      })


      require("snacks").setup(opts)
    end,
  }
}
