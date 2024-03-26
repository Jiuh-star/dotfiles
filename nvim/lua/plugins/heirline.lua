local M = {
    "rebelot/heirline.nvim",
    enabled = true,
    dependencies = {
        "catppuccin/nvim",
        "nvim-tree/nvim-web-devicons",
        "lewis6991/gitsigns.nvim",
        "SmiteshP/nvim-navic",
    }
}

-- Statusline Components --

--- Iconify the components.
---@param icon string|function
---@param component table
---@param highlight string|table|function
---@return table
local function iconify(icon, component, highlight)
    component = vim.tbl_deep_extend("force", component, {})

    local load_highlight = function(self)
        local hl = highlight

        if type(hl) == "function" then
            hl = highlight(self)
        end

        if type(hl) == "string" then
            return { fg = hl }
        elseif type(hl) == "table" then
            return hl
        else
            return {}
        end
    end

    return {
        {
            provider = '',
            hl = function(self)
                return { fg = load_highlight(self).fg }
            end,
        },
        {
            provider = (type(icon) == 'function' and icon) or icon,
            hl = function(self)
                return { fg = 'black', bg = load_highlight(self).fg or 'white' }
            end
        },
        {
            provider = ' ',
            hl = { bg = 'base' }
        },
        {
            hl = function(self)
                local hl = load_highlight(self)
                hl.bg = 'base'
                return hl
            end,
            component,
        },
        {
            provider = '',
            hl = { fg = 'base' },
        }
    }
end


-- block: placeholder
local Space = { provider = ' ' }
local Align = { provider = '%=' }


-- block: mode with neovim icon
local ViModeBlock = {
    init = function(self)
        self.mode = vim.fn.mode(1) -- get short (within 3 chars) mode name, see :h mode()
    end,
    static = {
        mode_names = {
            ['n'] = "NOR",
            ['no'] = "N?",
            ['nov'] = "N?",
            ['noV'] = "N?",
            ['no\22'] = "N?",
            ['niI'] = "Ni",
            ['niR'] = "Nr",
            ['niV'] = "Nv",
            ['nt'] = "Nt",
            ['v'] = "VIS",
            ['vs'] = "Vs",
            ['V'] = "V_",
            ['Vs'] = "Vs",
            ['\22'] = "^V",
            ['\22s'] = "^V",
            ['s'] = "SEL",
            ['S'] = "S_",
            ['\19'] = "^S",
            ['i'] = "INS",
            ['ic'] = "Ic",
            ['ix'] = "Ix",
            ['R'] = "REP",
            ['Rc'] = "Rc",
            ['Rx'] = "Rx",
            ['Rv'] = "Rv",
            ['Rvc'] = "Rv",
            ['Rvx'] = "Rv",
            ['c'] = "CMD",
            ['cv'] = "Ex",
            ['r'] = "...",
            ['rm'] = "M",
            ['r?'] = "?",
            ['!'] = "!",
            ['t'] = "TER",
        },
        mode_colors = {
            ['s'] = "pink",
            ['S'] = "pink",
            ["\19"] = "pink",
            ['R'] = "yellow",
            ['r'] = "yellow",
            ["!"] = "red",
            ["c"] = "red",
            ["t"] = "red",
            ['n'] = "blue",
            ['i'] = "green",
            ['v'] = "mauve",
            ['V'] = "mauve",
            ['\22'] = "mauve",

        },
    },
    update = {
        "ModeChanged",
        pattern = "*:*",
        callback = vim.schedule_wrap(function()
            vim.cmd("redrawstatus")
        end),
    },
}

local ViMode = {
    provider = function(self)
        return '%3(' .. (self.mode_names[self.mode] or self.mode) .. '%)'
    end,
}

ViMode = iconify(' ', ViMode, function(self) return { fg = self.mode_colors[self.mode], bold = true } end)

table.insert(ViModeBlock, ViMode)
table.insert(ViModeBlock, Space)


-- block: filename with file icon
local FileNameBlock = {
    init = function(self)
        self.filename = vim.api.nvim_buf_get_name(0)
        local ext = vim.fn.fnamemodify(self.filename, ":e")
        self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(self.filename, ext, { default = true })
    end,
}

local FileName = {
    provider = function(self)
        local conditions = require "heirline.conditions"

        local filename = vim.fn.fnamemodify(self.filename, ":~:.")
        if filename == "" then return "[No Name]" end

        if not conditions.width_percent_below(#filename, 0.25) then
            filename = vim.fn.pathshorten(filename)
        end
        return filename
    end,
    {
        condition = function()
            return vim.bo.modified
        end,
        provider = ' [+]',
    },
    {
        condition = function()
            return not vim.bo.modifiable or vim.bo.readonly
        end,
        provider = " ",
    },
}

FileName = iconify(
    function(self) return self.icon and (self.icon .. ' ') end,
    FileName,
    function(self)
        if vim.bo.modified then
            return { fg = self.icon_color, bold = true }
        end
        return self.icon_color
    end
)

table.insert(FileNameBlock, FileName)
table.insert(FileNameBlock, Space)


-- block: git sign
local GitBlock = {
    condition = function(_)
        return require('heirline.conditions').is_git_repo()
    end,
    init = function(self)
        ---@diagnostic disable-next-line
        self.status_dict = vim.b.gitsigns_status_dict
    end,
    hl = { fg = 'subtext0' },

    {
        -- git brance name
        provider = function(self)
            return ' ' .. self.status_dict.head
        end,
        hl = { bold = true },
    },
    {
        provider = function(self)
            local count = self.status_dict.added or 0
            return count > 0 and ('  ' .. count)
        end
    },
    {
        provider = function(self)
            local count = self.status_dict.removed or 0
            return count > 0 and (' 󰍶 ' .. count)
        end
    },
    {
        provider = function(self)
            local count = self.status_dict.changed or 0
            return count > 0 and (' 󰻂 ' .. count)
        end
    },
}


-- block: file encoding
local FileEncodingBlock = {
    provider = function()
        local enc = (vim.bo.fenc ~= '' and vim.bo.fenc) or vim.o.enc -- :h enc
        return enc:upper()
    end,
    hl = { fg = 'subtext0' },
    Space,
}


-- block: file format
local FileFormatBlock = {
    provider = function()
        local fmt = vim.bo.fileformat
        return fmt:upper()
    end,
    hl = { fg = 'subtext0' },
    Space,
}


-- block: diagnostic
local DiagnosticBlock = {
    condition = function()
        return require('heirline.conditions').has_diagnostics()
    end,
    static = {
        error_icon = ' ',
        warn_icon = ' ',
        info_icon = ' ',
        hint_icon = ' ',
    },
    init = function(self)
        self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
        self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
        self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
        self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
    end,
    update = { "DiagnosticChanged", "BufEnter" },

    {
        provider = function(self)
            -- 0 is just another output, we can decide to print it or not!
            return self.errors > 0 and (self.error_icon .. self.errors .. " ")
        end,
        hl = { fg = "red" },
    },
    {
        provider = function(self)
            return self.warnings > 0 and (self.warn_icon .. self.warnings .. " ")
        end,
        hl = { fg = "yellow" },
    },
    {
        provider = function(self)
            return self.info > 0 and (self.info_icon .. self.info .. " ")
        end,
        hl = { fg = "sky" },
    },
    {
        provider = function(self)
            return self.hints > 0 and (self.hint_icon .. self.hints)
        end,
        hl = { fg = "teal" },
    },
    Space,
}


-- block: LSP with icon
local LspBlock = {
    condition = function()
        return require("heirline.conditions").lsp_attached()
    end,
    update = { "LspAttach", "LspDetach" },
}

local Lsp = {
    provider = function()
        local names = {}
        for _, server in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
            table.insert(names, server.name)
        end
        return table.concat(names, ' ')
    end,
}

Lsp = iconify(' ', Lsp, "green")

table.insert(LspBlock, Lsp)
table.insert(LspBlock, Space)


-- block: position with icon
local RulerBlock = {
    provider = "%l/%3L"
}


RulerBlock = iconify(' ', RulerBlock, 'yellow')


-- Winbar --
local winbar = {
    fallthrough = false,
    init = function(self)
        self.filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t")
        local ext = vim.fn.fnamemodify(self.filename, ":e")
        self.icon = require("nvim-web-devicons").get_icon(self.filename, ext, { default = true })
    end,
    static = {
        seperator = ' > ',
    },
    condition = function()
        return require("heirline.conditions").is_active()
    end,
    provider = function(self)
        local breadcrumb = ''

        if self.filename and self.filename ~= '' then
            breadcrumb = self.icon .. ' ' .. self.filename
        else
            breadcrumb = '󰍛 BUF'
        end

        local navic = require "nvim-navic"
        if navic.is_available() then
            local location = navic.get_location()
            if location and location ~= '' then
                breadcrumb = breadcrumb .. self.seperator .. location
            end
        end

        return breadcrumb
    end,
}


-- Tabline --
local Tab = {
    init = function(self)
        self.filename = vim.api.nvim_buf_get_name(self.bufnr)
        self.filename = self.filename == '' and '[No Name]' or vim.fn.fnamemodify(self.filename, ':t')
        local ext = vim.fn.fnamemodify(self.filename, ":e")
        self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(self.filename, ext, { default = true })
        self.bg = 'crust'
    end,
    hl = function(self)
        return { bg = self.bg }
    end,

    { -- round corner
        provider = '',
        hl = function(self)
            return { fg = self.bg }
        end,
    },
    { -- file type icon
        provider = function(self)
            return self.icon .. ' '
        end,
        hl = function(self)
            return { fg = self.is_active and self.icon_color or 'subtext0', bg = self.bg }
        end,
    },
    { -- filename, may with readonly icon
        provider = function(self)
            local text = self.filename

            if not vim.api.nvim_get_option_value("modifiable", { buf = self.bufnr }) or vim.api.nvim_get_option_value("readonly", { buf = self.bufnr }) then
                text = text .. ' '
            end

            return text
        end,
        hl = function(self)
            if self.is_active then
                return { fg = 'white', bold = true, italic = true, bg = self.bg }
            else
                return { fg = 'subtext0', bg = self.bg }
            end
        end,
        on_click = {
            callback = function(_, minwid, _, _)
                vim.api.nvim_win_set_buf(0, minwid)
            end,
            minwid = function(self)
                return self.bufnr
            end,
            name = 'heirline_tabline_buffer_callback',
        },

        {      -- when file modified, we display modified icon
            condition = function(self)
                return vim.api.nvim_get_option_value("modified", { buf = self.bufnr })
            end,
            provider = '  ',
        },
        { -- otherwise display close button
            condition = function(self)
                return not vim.api.nvim_get_option_value("modified", { buf = self.bufnr })
            end,
            provider = '  ',
            on_click = {
                callback = function(_, minwid)
                    vim.schedule(function()
                        vim.api.nvim_buf_delete(minwid, { force = false })
                        vim.cmd.redrawtabline()
                    end)
                end,
                minwid = function(self)
                    return self.bufnr
                end,
                name = "heirline_tabline_close_buffer_callback",
            },
        },

    },
    {
        provider = '',
        hl = function(self)
            return { fg = self.bg }
        end,
    },
    Space
}

-- this is the default function used to retrieve buffers
local get_bufs = function()
    return vim.tbl_filter(function(bufnr)
        return vim.api.nvim_get_option_value("buflisted", { buf = bufnr })
    end, vim.api.nvim_list_bufs())
end

-- initialize the buflist cache
local buflist_cache = {}

-- setup an autocmd that updates the buflist_cache every time that buffers are added/removed
vim.api.nvim_create_autocmd({ "VimEnter", "UIEnter", "BufAdd", "BufDelete" }, {
    callback = function()
        vim.schedule(function()
            local buffers = get_bufs()
            for i, v in ipairs(buffers) do
                buflist_cache[i] = v
            end
            for i = #buffers + 1, #buflist_cache do
                buflist_cache[i] = nil
            end

            -- check how many buffers we have and set showtabline accordingly
            if #buflist_cache > 1 then
                vim.o.showtabline = 2 -- always
            elseif vim.o.showtabline ~= 1 then -- don't reset the option if it's already at default value
                vim.o.showtabline = 1 -- only when #tabpages > 1
            end
        end)
    end,
})


function M.config(_, _)
    local heirline = require "heirline"
    local conditions = require "heirline.conditions"
    local utils = require "heirline.utils"

    local colors = require "catppuccin.palettes.mocha"

    local statusline = {
        ViModeBlock, FileNameBlock, GitBlock, Align,
        FileEncodingBlock, FileFormatBlock, DiagnosticBlock, LspBlock, RulerBlock
    }

    local tabline = utils.make_buflist(
        Tab,
        { provider = "", hl = { fg = "gray" } },
        { provider = "", hl = { fg = "gray" } },
        -- out buf_func simply returns the buflist_cache
        function()
            return buflist_cache
        end,
        -- no cache, as we're handling everything ourselves
        false
    )

    heirline.setup {
        statusline = statusline,
        winbar = winbar,
        tabline = tabline,
        opts = {
            colors = colors,
            disable_winbar_cb = function(args)
                return conditions.buffer_matches({
                    buftype = { "nofile", "prompt", "help", "quickfix", "terminal" },
                    filetype = { "^git.*", "fugitive", "Trouble", "dashboard" }
                }, args.buf)
            end,
        }
    }
end

return M
