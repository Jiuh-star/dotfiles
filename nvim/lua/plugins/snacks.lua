return {
  -- snacks
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      quickfile = { enabled = true },
      animate = { enabled = true },
      scroll = { enabled = true },
      indent = {
        enabled = true,
        chunk = {
          enabled = true,
          char = { corner_top = "╭", corner_bottom = "╰", arrow = "" },
        },
      },
      dim = { enabled = true },
      gitbrowse = { enabled = true },
      picker = { enabled = true },
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
          toggle
            .option("background", { off = "light", on = "dark", name = "Dark Background" })
            :map(keymaps.ui.background)
          toggle.option("wrap", { name = "Wrap line" }):map(keymaps.ui.wrap)
          toggle.scroll():map(keymaps.ui.scroll)

          -- git
          wk.add({ keymaps.git.lazygit, function() Snacks.lazygit() end, desc = "LazyGit", icon = " " })

          -- top
          wk.add({ keymaps.top.smart, function() Snacks.picker.smart() end, desc = "Smart Find Files", icon = " " })
          wk.add({ keymaps.top.buffer, function() Snacks.picker.buffers() end, desc = "Buffers", icon = "﬘ " })
          wk.add({ keymaps.top.grep, function() Snacks.picker.grep() end, desc = "Grep", icon = " " })
          wk.add({
            keymaps.top.command_history,
            function() Snacks.picker.command_history() end,
            desc = "Command History",
            icon = " ",
          })
          wk.add({
            keymaps.top.notification,
            function() Snacks.picker.notifications() end,
            desc = "Notification History",
            icon = "󱅳 ",
          })
          wk.add({
            keymaps.top.explorer,
            function() Snacks.picker.explorer() end,
            desc = "File Explorer",
            icon = " ",
          })

          vim.api.nvim_create_user_command("LazyGit", function() Snacks.lazygit() end, {})
        end,
      })

      require("snacks").setup(opts)
    end,
  },
}
