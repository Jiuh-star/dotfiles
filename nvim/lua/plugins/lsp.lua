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
      local config = require("user.config")

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
              [vim.diagnostic.severity.ERROR] = config.icons.diagnostics_error,
              [vim.diagnostic.severity.WARN] = config.icons.diagnostics_warn,
              [vim.diagnostic.severity.INFO] = config.icons.diagnostics_info,
              [vim.diagnostic.severity.HINT] = config.icons.diagnostics_hint,
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
          vue_ls = {
            on_init = function(client)
              client.handlers["tsserver/request"] = function(_, result, context)
                local ts_clients = vim.lsp.get_clients({ bufnr = context.bufnr, name = "ts_ls" })
                local vtsls_clients = vim.lsp.get_clients({ bufnr = context.bufnr, name = "vtsls" })
                local clients = {}

                vim.list_extend(clients, ts_clients)
                vim.list_extend(clients, vtsls_clients)

                if #clients == 0 then
                  vim.notify(
                    "Could not find `vtsls` or `ts_ls` lsp client, `vue_ls` would not work without it.",
                    vim.log.levels.ERROR
                  )
                  return
                end
                local ts_client = clients[1]

                local param = unpack(result)
                local id, command, payload = unpack(param)
                ts_client:exec_cmd({
                  title = "vue_request_forward", -- You can give title anything as it's used to represent a command in the UI, `:h Client:exec_cmd`
                  command = "typescript.tsserverRequest",
                  arguments = {
                    command,
                    payload,
                  },
                }, { bufnr = context.bufnr }, function(_, r)
                  local response = r and r.body
                  -- TODO: handle error or response nil here, e.g. logging
                  -- NOTE: Do NOT return if there's an error or no response, just return nil back to the vue_ls to prevent memory leak
                  local response_data = { { id, response } }

                  ---@diagnostic disable-next-line: param-type-mismatch
                  client:notify("tsserver/response", response_data)
                end)
              end
            end,
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
        vim.lsp.config(server, config)
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
