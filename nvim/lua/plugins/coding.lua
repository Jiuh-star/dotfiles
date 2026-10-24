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
      local keymaps = require("config.keys").language

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

      wk.add({ keymaps.format, "<cmd>Format<cr>", desc = "Format Buffer", icon = "󰮳 " })
      wk.add({
        keymaps.definition,
        function() Snacks.picker.lsp_definitions() end,
        desc = "Goto Definition",
        icon = " ",
      })
      wk.add({
        keymaps.declaration,
        function() Snacks.picker.lsp_declarations() end,
        desc = "Goto Declaration",
        icon = " ",
      })
      wk.add({
        keymaps.reference,
        function() Snacks.picker.lsp_references() end,
        desc = "Goto References",
        icon = " ",
      })
      wk.add({
        keymaps.implementation,
        function() Snacks.picker.lsp_implementations() end,
        desc = "Goto Implementation",
        icon = "󰊕 ",
      })
      wk.add({
        keymaps.type_definition,
        function() Snacks.picker.lsp_type_definitions() end,
        desc = "Goto Type Definition",
        icon = " ",
      })
      wk.add({
        keymaps.incoming_call,
        function() Snacks.picker.lsp_incoming_calls() end,
        desc = "Calls Incoming",
        icon = " ",
      })
      wk.add({
        keymaps.outgoing_call,
        function() Snacks.picker.lsp_outgoing_calls() end,
        desc = "Calls Outgoing",
        icon = " ",
      })
      wk.add({
        keymaps.symbol,
        function() Snacks.picker.lsp_symbols() end,
        desc = "LSP Symbol",
        icon = " ",
      })
      wk.add({
        keymaps.workspace_symbol,
        function() Snacks.picker.lsp_workspace_symbols() end,
        desc = "LSP Workspace Symbol",
        icon = " ",
      })

      require("conform").setup(opts)
    end,
  },

  -- treesitter manager
  {
    "romus204/tree-sitter-manager.nvim",
    cmd = { "TSManager", "TSInstall", "TSUninstall", "TSUpdate" },
    opts = {
      auto_install = true,
    },
  },

  -- typst
  {
    "chomosuke/typst-preview.nvim",
    ft = { "typst" },
    opts = {
      port = 9999, -- static for port forwarding
      dependencies_bin = { tinymist = "tinymist" },
    },
  },

  -- annotation generation
  {
    "danymat/neogen",
    event = { "BufWritePre", "VeryLazy" },
    cmd = { "Neogen" },
    opts = {
      snippet_engine = "nvim",
    },
    config = function(_, opts)
      local wk = require("which-key")
      local keymaps = require("config.keys").language

      wk.add({
        keymaps.annotation,
        function() require("neogen").generate() end,
        desc = "Generate Annotation",
        icon = "󰷉 ",
      })

      require("neogen").setup(opts)
    end,
  },

  -- test suite manager
  {
    "nvim-neotest/neotest",
    event = { "BufWritePre", "VeryLazy" },
    cmd = { "Neotest" },
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-neotest/neotest-python",
      "mrcjkb/rustaceanvim",
    },
    config = function()
      local wk = require("which-key")
      local keys = require("config.keys").test
      local neotest = require("neotest")

      local opts = {
        adapters = {
          require("neotest-python")({
            dap = { justMyCode = false },
          }),
        },
      }

      wk.add({
        keys.attach,
        function() neotest.run.attach() end,
        desc = "Attach to Test",
        icon = " ",
      })
      wk.add({
        keys.run_file,
        function() neotest.run.run(vim.fn.expand("%")) end,
        desc = "Run File",
        icon = "󱈬 ",
      })
      wk.add({
        keys.run_all,
        function() neotest.run.run(vim.uv.cwd()) end,
        desc = "Run All",
        icon = "󰚐 ",
      })
      wk.add({
        keys.nearest,
        function() neotest.run.run() end,
        desc = "Run Nearest",
        icon = "󰡕 ",
      })
      wk.add({
        keys.last,
        function() neotest.run.run_last() end,
        desc = "Run Last",
        icon = "󰡕 ",
      })
      wk.add({
        keys.summary,
        function() neotest.summary.toggle() end,
        desc = "Summary",
        icon = " ",
      })
      wk.add({
        keys.output,
        function() neotest.output.open({ enter = true, auto_close = true }) end,
        desc = "Show Output",
        icon = " ",
      })
      wk.add({
        keys.output_panel,
        function() neotest.output_panel.toggle() end,
        desc = "Output Panel",
        icon = "󰺧 ",
      })
      wk.add({
        keys.stop,
        function() neotest.run.stop() end,
        desc = "Stop",
        icon = " ",
      })
      wk.add({
        keys.watch,
        function() neotest.watch.toggle(vim.fn.expand("%")) end,
        desc = "Toggle Watch",
        icon = " ",
      })

      neotest.setup(opts)
    end,
  },
}
