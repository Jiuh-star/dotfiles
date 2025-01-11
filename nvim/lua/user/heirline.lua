local M = {}

local utils = require("heirline.utils")
local conditions = require("heirline.conditions")
local config = require("user.config")
local icons = config.icons

M.setup_colors = function()
  return {
    base = utils.get_highlight("Tabline").bg,
    text = utils.get_highlight("StatusLine").fg,
    subtext = utils.get_highlight("StatusLineNC").fg,
    red = utils.get_highlight("DiagnosticError").fg,
    green = utils.get_highlight("String").fg,
    blue = utils.get_highlight("Function").fg,
    yellow = utils.get_highlight("healthWarning").fg,
    gray = utils.get_highlight("Comment").fg,
    orange = utils.get_highlight("Constant").fg,
    purple = utils.get_highlight("Statement").fg,
    pink = utils.get_highlight("Special").fg,
  }
end

local get_hl = function(self, hl)
  if type(hl) == "function" then
    return hl(self)
  end
  return hl
end

local bubble = function(component)
  component = utils.clone(component)

  local old_provider = component.provider
  local old_hl = component.hl
  local subcomponents = {}

  for i, subcomponent in ipairs(component) do
    if type(subcomponent) == "table" then
      table.insert(subcomponents, subcomponent)
      component[i] = nil
    end
  end
  component.provider = nil

  local bubble = {
    -- left bubble
    {
      provider = "",
      hl = function(self)
        local hl = get_hl(self, component.hl)
        if hl then
          return { fg = hl.fg, bg = "none" }
        end
      end,
    },
    -- icon
    {
      provider = function(self)
        if type(component.icon) == "function" then
          return component.icon(self) .. " "
        end
        return component.icon .. " "
      end,
      hl = function(self)
        local hl = get_hl(self, component.hl)
        if hl then
          return { fg = "base", bg = hl.fg }
        end
      end,
    },
    -- space
    {
      provider = " ",
      hl = { fg = "none", bg = "base" },
    },
    -- modified component
    {
      provider = old_provider,
      hl = function(self)
        local hl = get_hl(self, old_hl)
        if hl then
          return { fg = hl.fg, bg = "base", bold = hl.bold, italic = hl.italic }
        end
      end,
      subcomponents,
    },
    -- right bubble
    {
      provider = "",
      hl = { fg = "base", bg = "none" },
    },
  }

  table.insert(component, bubble)

  return component
end

-- store global variables
local global = {
  hl = function()
    if conditions.is_active() then
      return { fg = "text", bg = "none" }
    else
      return { fg = "subtext", bg = "none" }
    end
  end,
}

M.space = { provider = " " }

M.align = { provider = "%=" }

M.mode = bubble({
  static = {
    mode_names = {
      ["n"] = "NOR",
      ["no"] = "NOR op",
      ["nov"] = "NOR ov",
      ["noV"] = "NOR oV",
      ["noCTRL-V"] = "NOR CV",
      ["niI"] = "NOR iI",
      ["niR"] = "NOR iR",
      ["niV"] = "NOR iV",
      ["nt"] = "NOR T",
      ["ntT"] = "NOR tT",

      ["v"] = "VIS",
      ["vs"] = "VIS SEL",
      ["V"] = "VIS L",
      ["Vs"] = "VIS L SEL",
      [""] = "VIS CV",

      ["i"] = "INS",
      ["ic"] = "INS c",
      ["ix"] = "INS x",

      ["t"] = "TER",

      ["R"] = "REP",
      ["Rc"] = "REP c",
      ["Rx"] = "REP x",
      ["Rv"] = "REP v",
      ["Rvc"] = "REP vc",
      ["Rvx"] = "REP vx",

      ["s"] = "SEL",
      ["S"] = "SEL L",
      [""] = "SEL CS",

      ["c"] = "CMD",
      ["cv"] = "CMD",
      ["ce"] = "CMD",
      ["cr"] = "CMD",

      ["r"] = "?",
      ["rm"] = "MORE",
      ["r?"] = "?",
      ["x"] = "?",
      ["!"] = "!",
    },
    mode_colors = {
      n = "blue",
      i = "green",
      v = "purple",
      V = "purple",
      [""] = "purple",
      c = "red",
      s = "yellow",
      S = "yellow",
      [""] = "yellow",
      R = "orange",
      r = "orange",
      ["!"] = "red",
      t = "red",
    },
  },

  init = function(self)
    self.mode = vim.api.nvim_get_mode().mode
  end,

  icon = icons.mode,

  provider = function(self)
    return self.mode_names[self.mode]
  end,

  hl = function(self)
    local mode = self.mode:sub(1, 1)
    return { fg = self.mode_colors[mode], bold = true }
  end,

  update = {
    "ModeChanged",
    pattern = "*:*",
    callback = vim.schedule_wrap(function()
      vim.api.nvim__redraw({ statusline = true })
      -- vim.cmd("redrawstatus")
    end),
  },
})

M.file = bubble({
  static = {
    default_file_icon = icons.file,
    default_file_color = "purple",
  },

  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(0)
    local ext = vim.fn.fnamemodify(self.filename, ":e")
    local ok, devicons = pcall(require, "nvim-web-devicons")
    if ok then
      self.file_icon, self.icon_color = devicons.get_icon_color(self.filename, ext, { default = true })
    end
  end,

  icon = function(self)
    return self.file_icon or self.default_file_icon
  end,

  provider = function(self)
    if vim.bo.filetype == "help" then
      return vim.fn.fnamemodify(self.filename, ":t")
    end

    local filename = vim.fn.fnamemodify(self.filename, ":.")
    if filename == "" then
      return "[NO NAME]"
    end
    if not conditions.width_percent_below(#filename, 0.25) then
      filename = vim.fn.pathshorten(filename)
    end
    return filename
  end,

  hl = function(self)
    return { fg = self.icon_color or self.default_file_color, bold = vim.bo.modified }
  end,

  update = {
    "TextChangedI",
    "TextChanged",
    "BufWritePost",
    "BufEnter",
    "BufNewFile",
    "WinEnter",
  },

  {
    condition = function()
      return vim.bo.modified
    end,
    provider = " ",
  },

  {
    condition = function()
      return not vim.bo.modifiable or vim.bo.readonly
    end,
    provider = "  ",
  },
})

M.git = {
  condition = conditions.is_git_repo,

  init = function(self)
    self.status_dict = vim.b.gitsigns_status_dict
  end,

  provider = function(self)
    local git_status = self.status_dict
    local added = (git_status.added and git_status.added ~= 0) and (" " .. icons.git_added .. " " .. git_status.added)
      or ""
    local changed = (git_status.changed and git_status.changed ~= 0)
        and (" " .. icons.git_changed .. " " .. git_status.changed)
      or ""
    local removed = (git_status.removed and git_status.removed ~= 0)
        and (" " .. icons.git_removed .. " " .. git_status.removed)
      or ""
    local branch = icons.git_branch .. " " .. git_status.head

    return branch .. added .. changed .. removed
  end,

  hl = { fg = "subtext" },
}

M.lsp = bubble({
  condition = conditions.lsp_attached,

  update = { "LspAttach", "LspDetach" },

  init = function(self)
    local names = {}
    self.copilot_icon = false

    for _, server in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
      if server.name == "copilot" then
        vim.notify(icons.copilot .. " Copilot is actived", vim.log.levels.INFO)
        self.copilot_icon = true
      else
        table.insert(names, server.name)
      end
    end

    -- if only copilot is active, show only copilot
    if #names == 1 and names[1] == "copilot" then
      self.copilot_icon = false
      names = { "copilot" }
    end

    self.names = names
  end,

  icon = function(self)
    return self.copilot_icon and icons.copilot or icons.lsp
  end,

  provider = function(self)
    return table.concat(self.names, " ")
  end,

  hl = { fg = "green" },
})

M.cursor = bubble({
  icon = icons.cursor,

  provider = function()
    local curr_line = vim.api.nvim_win_get_cursor(0)[1]
    local lines = vim.api.nvim_buf_line_count(0)

    if curr_line == 1 then
      return "TOP"
    elseif curr_line == lines then
      return "BOT"
    end

    local p = math.floor((curr_line - 1) / lines * 100)

    return p .. "%%"
  end,

  hl = { fg = "yellow" },
})

M.encoding = {
  provider = function()
    local enc = (vim.bo.fenc ~= "" and vim.bo.fenc) or vim.o.enc
    return enc:upper()
  end,

  hl = { fg = "subtext" },
}

M.diagnostic = {
  condition = conditions.has_diagnostics,

  init = function(self)
    self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
    self.infos = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
  end,

  update = { "DiagnosticChanged", "BufEnter" },

  {
    provider = function(self)
      return self.errors > 0 and (icons.diagnostics_error .. " " .. self.errors .. " ")
    end,

    hl = { fg = "red" },
  },

  {
    provider = function(self)
      return self.warnings > 0 and (icons.diagnostics_warn .. " " .. self.warnings .. " ")
    end,

    hl = { fg = "yellow" },
  },

  {
    provider = function(self)
      return self.hints > 0 and (icons.diagnostics_hint .. " " .. self.hints .. " ")
    end,

    hl = { fg = "blue" },
  },

  {
    provider = function(self)
      return self.infos > 0 and (icons.diagnostics_info .. " " .. self.infos .. " ")
    end,

    hl = { fg = "green" },
  },
}

M.setup = function(opts)
  -- (string) opts.statusline -> (table) actual statusline
  local statusline = utils.clone(global)
  for i, name in ipairs(opts.statusline) do
    if i ~= 0 then
      table.insert(statusline, M.space)
    end

    local component = M[name]
    if component then
      table.insert(statusline, component)
    end
  end
  opts.statusline = statusline

  require("heirline").setup(opts)

  vim.api.nvim_create_augroup("Heirline", { clear = true })
  vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
      utils.on_colorscheme(M.setup_colors)
    end,
    group = "Heirline",
  })
end

return M
