return {
  -- formatters
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre", "VeryLazy" },
    cmd = { "ConformInfo", "Format" },
    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff_format", "ruff_organize_imports" },
        rust = { "rustfmt" },
        ["-"] = { "trim_whitespace" },
      },
      default_format_opts = {
        lsp_format = "fallback",
      },
    },
    config = function(_, opts)
      local conform = require("conform")
      local wk = require("which-key")
      local keymaps = vim.g.keymaps.language

      vim.api.nvim_create_user_command("Format", function(args)
        local range = nil -- format the whole buffer by default
        -- otherwise, format the selected range
        if args.count ~= -1 then
          local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
          range = {
            start = { args.line1, 0 },
            ["end"] = { args.line2, end_line:len() },
          }
        end
        conform.format({ async = true, lsp_format = "fallback", range = range })
      end, { range = true })

      wk.add({ keymaps.format, "<cmd>Format<cr>", desc = "Format Buffer", icon = "󰉢 " })

      require("conform").setup(opts)
    end,
  },

  -- treesitter manager
  {
    "romus204/tree-sitter-manager.nvim",
    cmd = { "TSManager", "TSInstall", "TSUninstall", "TSUpdate" },
    opts = {
      auto_install = true
    }
  },
}
