return {
  -- formatters
  {
    "stevearc/conform.nvim",
    opts = {},
  },
  --treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    build = ":TSUpdate",
    -- lazy = vim.fn.argc(-1) == 0,
    init = function(plugin)
      require("lazy.core.loader").add_to_rtp(plugin)
      require("nvim-treesitter.query_predicates")
    end,
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
        "comment",
        "caddy",
      },
    },
    ---@param opts TSConfig
    config = function(_, opts)
      require("nvim-treesitter.parsers").get_parser_configs().caddy = {  ---@diagnostic disable-line
        install_info = {
          url = "https://github.com/Samonitari/tree-sitter-caddy",
          files = { "src/parser.c", "src/scanner.c" },
          branch = "master",
        },
        filetype = "caddy",
      }
      vim.filetype.add({
        pattern = {
          ["Caddyfile"] = "caddy",
        }
      })

      require("nvim-treesitter.configs").setup(opts)
    end
  },
}
