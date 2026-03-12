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
        python = { "ruff_format" },
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
        local range = nil
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

  --treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    version = false,
    build = ":TSUpdate",
    lazy = false,
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    event = "VeryLazy",
    ---@type TSConfig
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
      ensure_installed = {
        "bash",
        "c",
        "diff",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "jsonc",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "printf",
        "python",
        "query",
        "regex",
        "toml",
        "vim",
        "xml",
        "yaml",
        "css",
        "http",
        "sql",
        "meson",
        "gitcommit",
        "gitignore",
        -- "comment",
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "VeryLazy",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = function(_, opts)
      Snacks.toggle
        .new({
          id = "treesitter-context",
          name = "Treesitter Context",
          get = function()
            return require("treesitter-context").enabled()
          end,
          set = function(state)
            local context = require("treesitter-context")
            if state then
              context.enable()
            else
              context.disable()
            end
          end,
        })
        :map("<leader>uc")
      return opts or {}
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event = "VeryLazy",
    opts = {},
    config = function(_, opts)
      local TS = require("nvim-treesitter.configs")
      if not TS.setup then
        vim.notify("Please use `:Lazy` and update `nvim-treesitter`", vim.log.levels.ERROR)
        return
      end
      TS.setup(opts)
    end,
  },
}
