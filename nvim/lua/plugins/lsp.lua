return {
  -- lsp
  {
    "neovim/nvim-lspconfig",
    event = "VeryLazy",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "saghen/blink.cmp",
    },
    opts = function()
      local icons = require("config.icons")
      local vue = require("lib.vue")

      return {
        ---@type vim.diagnostic.Opts
        diagnostics = {
          underline = true,
          update_in_insert = false,
          virtual_text = {
            spacing = 4,
            source = "if_many",
            prefix = "●",
          },
          severity_sort = true,
          signs = {
            text = {
              [vim.diagnostic.severity.ERROR] = icons.diagnostics_error,
              [vim.diagnostic.severity.WARN] = icons.diagnostics_warn,
              [vim.diagnostic.severity.INFO] = icons.diagnostics_info,
              [vim.diagnostic.severity.HINT] = icons.diagnostics_hint,
            },
          },
        },
        inlay_hints = {
          enabled = true,
          exclude = {},
        },
        codelens = {
          enabled = true,
        },
        capabilities = {
          workspace = {
            fileOperations = {
              didRename = true,
              willRename = true,
            },
          },
        },
        format = {
          formatting_options = nil,
          timeout_ms = nil,
        },
        servers = {
          lua_ls = {},
          basedpyright = {},
          ruff = {},
          vtsls = {
            settings = {
              vtsls = {
                tsserver = {
                  globalPlugins = {
                    {
                      name = "@vue/typescript-plugin",
                      location = vim.fn.stdpath("data")
                        .. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
                      language = { "vue" },
                      configNamespace = "typescript",
                    },
                  },
                },
              },
            },
            filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
          },
          vue_ls = { on_init = vue.on_init },
          tinymist = {
            cmd = { "tinymist" },
            filetypes = { "typst" },
            root_markers = { "typst.toml", ".git" },
            settings = {
              formatterMode = "typstyle",
              exportPdf = "onType",
              semanticTokens = "disable",
            },
          },
          -- harper_ls = {
          --   markdown = {
          --     ignore_link_title = true
          --   },
          --   isolateEnglish = false,
          --   userDictPath = vim.fn.stdpath("config") .. "/spell/en.utf-8.add",
          -- }
        },
      }
    end,
    config = function(_, opts)
      -- diagnostics
      for severity, icon in pairs(opts.diagnostics.signs.text) do
        local name = vim.diagnostic.severity[severity]:lower():gsub("^%l", string.upper)
        name = "DiagnosticSign" .. name
        vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
      end

      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      -- lsp
      for server, config in pairs(opts.servers) do
        config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
        vim.lsp.config[server] = config
      end
    end,
  },

  -- formatter & lsp manager
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {
      ui = {
        border = "rounded",
      },
    },
  },

  -- lspconfig manager
  {
    "williamboman/mason-lspconfig.nvim",
    event = "VeryLazy",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      automatic_installation = true,
    },
  },

  -- linter
  {
    "mfussenegger/nvim-lint",
    event = { "VeryLazy", "BufWritePost", "InsertLeave" },
    dependencies = { "rshkarin/mason-nvim-lint" },
    opts = {
      events = { "BufWritePost", "InsertLeave" },
      linters_by_ft = {
        python = { "ruff" },
        -- ["_"] = { "codespell" },
      },
      markers = {},
    },
    config = function(_, opts)
      local lint = require("lint")
      local wk = require("which-key")
      local keys = require("config.keys").language

      lint.linters_by_ft = opts.linters_by_ft

      local function find_lint_root(bufnr, markers)
        local start = vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr))
        if start == "" then return end

        local lsp_root = nil

        for _, c in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
          if c.root_dir then lsp_root = vim.fs.normalize(c.root_dir) end
        end

        for _, path in ipairs(vim.fs.find(markers, { path = start, upward = true })) do
          local dir = vim.fs.dirname(path)
          if not lsp_root or vim.fs.relpath(lsp_root, dir) then return dir end
        end

        return lsp_root
      end

      local function try_lint()
        local linters = lint.linters_by_ft[vim.bo.filetype]
        if not linters or #linters == 0 then return end

        lint.try_lint(linters, {
          wrap_linter = function(linter)
            local markers = opts.markers[linter.name] or { ".git" }
            linter.cwd = find_lint_root(0, markers)
            return linter
          end,
        })
      end

      vim.api.nvim_create_autocmd(opts.events, { callback = try_lint })

      wk.add({ keys.lint, try_lint, desc = "Lint Current Buffer", icon = "󱝀 " })
    end,
  },

  -- lint config manager
  {
    "rshkarin/mason-nvim-lint",
    event = "VeryLazy",
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-lint",
    },
    opts = {
      automatic_installation = true,
    },
  },

  -- developing for NeoVim
  {
    "folke/lazydev.nvim",
    dependencies = {
      { "LelouchHe/xmake-luals-addon", lazy = true },
      { "DrKJeff16/wezterm-types", lazy = true },
    },
    ft = "lua",
    cmd = "LazyDev",
    opts = {
      library = {
        "lazy.nvim",
        "snacks.nvim",
        "which-key.nvim",
        "bufferline.nvim",
        "conform.nvim",
        "neotest",
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { "xmake-luals-addon/library", file = { "xmake.lua" } },
        { path = "wezterm-types", mods = { "wezterm" } },
      },
    },
  },

  -- AI programming
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
      },
      panel = { enabled = false },
    },
    config = function(_, opts)
      -- hide copilot on blink.cmp's suggestion
      vim.api.nvim_create_autocmd("User", {
        pattern = "BlinkCmpMenuOpen",
        callback = function()
          require("copilot.suggestion").dismiss()
          vim.b.copilot_suggestion_hidden = true
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "BlinkCmpMenuClose",
        callback = function() vim.b.copilot_suggestion_hidden = false end,
      })
      require("copilot").setup(opts)
    end,
  },
}
