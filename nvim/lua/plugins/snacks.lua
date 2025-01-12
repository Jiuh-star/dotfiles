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
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          _G.dd = function(...)  ---@diagnostic disable-line:duplicate-set-field
            Snacks.debug(...)
          end
          _G.bt = function()  ---@diagnostic disable-line:duplicate-set-field
            Snacks.debug.backtrace()
          end
          vim.print = _G.dd

          Snacks.toggle.dim():map("<leader>uD")
          Snacks.toggle.indent():map("<leader>ui")
          Snacks.toggle.inlay_hints():map("<leader>uh")
          Snacks.toggle.treesitter():map("<leader>ut")
          Snacks.toggle.diagnostics():map("<leader>ud")
          Snacks.toggle.line_number():map("<leader>ul")
          Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
          Snacks.toggle.option("wrap", { name = "Wrap line" }):map("<leader>uw")

          Snacks.toggle.dim():set(true)
        end
      })
    end
  }
}
