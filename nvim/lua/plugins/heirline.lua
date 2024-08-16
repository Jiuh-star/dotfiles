--- Iconify the components
--- @param icon string|function
--- @param component table
--- @param highlight string|table|function
--- @return table
local function iconify(icon, component, highlight)
    component = vim.tbl_deep_extend('force', component, {})

    local load_highlight = function(self)
        local hl = highlight

        if type(hl) == 'function' then
            hl = highlight(self)
        end

        if type(hl) == 'string' then
            return { fg = hl }
        elseif type(hl) == 'table' then
            return hl
        else
            return {}
        end
    end

    return {
        {
            provider = '',
            hl = function(self)
                return { fg = load_highlight(self).fg, bg = false }
            end,
        },
        {
            provider = icon,
            hl = function(self)
                return { fg = 'bright_bg', bg = load_highlight(self).fg or 'bright_fg' }
            end
        },
        {
            provider = ' ',
            hl = { bg = 'bright_bg' }
        },
        {
            hl = function(self)
                local hl = load_highlight(self)
                hl.bg = 'bright_bg'
                return hl
            end,
            component,
        },
        {
            provider = '',
            hl = { fg = 'bright_bg', bg = false },
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
            ['n'] = 'NOR',
            ['no'] = 'N?',
            ['nov'] = 'N?',
            ['noV'] = 'N?',
            ['no\22'] = 'N?',
            ['niI'] = 'Ni',
            ['niR'] = 'Nr',
            ['niV'] = 'Nv',
            ['nt'] = 'Nt',
            ['v'] = 'VIS',
            ['vs'] = 'Vs',
            ['V'] = 'V_',
            ['Vs'] = 'Vs',
            ['\22'] = '^V',
            ['\22s'] = '^V',
            ['s'] = 'SEL',
            ['S'] = 'S_',
            ['\19'] = '^S',
            ['i'] = 'INS',
            ['ic'] = 'Ic',
            ['ix'] = 'Ix',
            ['R'] = 'REP',
            ['Rc'] = 'Rc',
            ['Rx'] = 'Rx',
            ['Rv'] = 'Rv',
            ['Rvc'] = 'Rv',
            ['Rvx'] = 'Rv',
            ['c'] = 'CMD',
            ['cv'] = 'Ex',
            ['r'] = '...',
            ['rm'] = 'M',
            ['r?'] = '?',
            ['!'] = '!',
            ['t'] = 'TER',
        },
        mode_colors = {
            ['s'] = 'mode_select',
            ['S'] = 'mode_select',
            ['\19'] = 'mode_select',
            ['R'] = 'mode_replace',
            ['r'] = 'mode_replace',
            ['!'] = 'mode_command',
            ['c'] = 'mode_command',
            ['t'] = 'mode_terminal',
            ['n'] = 'mode_normal',
            ['i'] = 'mode_insert',
            ['v'] = 'mode_visual',
            ['V'] = 'mode_visual',
            ['\22'] = 'mode_visual',
        },
    },
    update = {
        'ModeChanged',
        pattern = '*:*',
        callback = vim.schedule_wrap(function()
            vim.cmd('redrawstatus')
        end),
    },
}

local ViMode = {
    provider = function(self)
        return '%3(' .. (self.mode_names[self.mode] or self.mode) .. '%)'
    end,
}

ViMode = iconify(' ', ViMode, function(self) return { fg = self.mode_colors[self.mode] or 'fg', bold = true } end)

table.insert(ViModeBlock, ViMode)
table.insert(ViModeBlock, Space)

-- block: filename with file icon
local FileNameBlock = {
    init = function(self)
        self.filename = vim.api.nvim_buf_get_name(0)
        local ext = vim.fn.fnamemodify(self.filename, ':e')
        self.icon, self.icon_color = require('nvim-web-devicons').get_icon_color(self.filename, ext, { default = true })
    end,
}

local FileName = {
    provider = function(self)
        local conditions = require 'heirline.conditions'

        local filename = vim.fn.fnamemodify(self.filename, ':~:.')
        if filename == '' then return '[No Name]' end

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
        provider = ' ',
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
    hl = { fg = 'dark_fg' },

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
    hl = { fg = 'dark_fg' },
    Space,
}


-- block: file format
local FileFormatBlock = {
    provider = function()
        local fmt = vim.bo.fileformat
        return fmt:upper()
    end,
    hl = { fg = 'dark_fg' },
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
    update = { 'DiagnosticChanged', 'BufEnter' },

    {
        provider = function(self)
            -- 0 is just another output, we can decide to print it or not!
            return self.errors > 0 and (self.error_icon .. self.errors .. ' ')
        end,
        hl = { fg = 'diag_error' },
    },
    {
        provider = function(self)
            return self.warnings > 0 and (self.warn_icon .. self.warnings .. ' ')
        end,
        hl = { fg = 'diag_warn' },
    },
    {
        provider = function(self)
            return self.info > 0 and (self.info_icon .. self.info .. ' ')
        end,
        hl = { fg = 'diag_info' },
    },
    {
        provider = function(self)
            return self.hints > 0 and (self.hint_icon .. self.hints)
        end,
        hl = { fg = 'diag_hint' },
    },
    Space,
}


-- block: LSP with icon
local LspBlock = {
    condition = function()
        return require('heirline.conditions').lsp_attached()
    end,
    update = { 'LspAttach', 'LspDetach' },
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

Lsp = iconify(' ', Lsp, 'lsp')

table.insert(LspBlock, Lsp)
table.insert(LspBlock, Space)


-- block: position with icon
local RulerBlock = {
    provider = '%l/%L'
}


RulerBlock = iconify(' ', RulerBlock, 'ruler')



return {
    'rebelot/heirline.nvim',
    dependencies = {
        'catppuccin/nvim',
        'nvim-tree/nvim-web-devicons',
        'lewis6991/gitsigns.nvim',
    },
    config = function()
        local heirline = require('heirline')
        local utils = require('heirline.utils')

        local function setup_colors()
            return {
                bright_bg = 'black',
                bright_fg = utils.get_highlight('Statusline').fg or 'white',
                dark_fg = utils.get_highlight('LspInlayHint').fg,

                diag_error = utils.get_highlight('DiagnosticSignError').fg,
                diag_warn = utils.get_highlight('DiagnosticSignWarn').fg,
                diag_info = utils.get_highlight('DiagnosticSignInfo').fg,
                diag_hint = utils.get_highlight('DiagnosticSignHint').fg,
                diag_ok = utils.get_highlight('DiagnosticSignOk').fg,

                git_add = utils.get_highlight('Added').fg,
                git_del = utils.get_highlight('Removed').fg,
                git_change = utils.get_highlight('Changed').fg,

                mode_normal = utils.get_highlight('Function').fg,
                mode_insert = utils.get_highlight('String').fg,
                mode_visual = utils.get_highlight('Keyword').fg,
                mode_replace = utils.get_highlight('Type').fg,
                mode_command = utils.get_highlight('ErrorMsg').fg,
                mode_terminal = utils.get_highlight('ErrorMsg').fg,
                mode_select = utils.get_highlight('Special').fg,

                ruler = utils.get_highlight('Structure').fg,
                lsp = utils.get_highlight('Special').fg,
                file = utils.get_highlight('Character').fg,
            }
        end

        local statusline = {
            hl = { fg = 'bright_fg', bg = false },
            ViModeBlock,
            FileNameBlock,
            GitBlock,
            Align,
            FileEncodingBlock,
            FileFormatBlock,
            DiagnosticBlock,
            LspBlock,
            RulerBlock
        }

        vim.api.nvim_create_augroup('Heirline', { clear = true })
        vim.api.nvim_create_autocmd('Colorscheme', {
            callback = function()
                utils.on_colorscheme(setup_colors)
            end,
            group = 'Heirline',
        })

        heirline.setup {
            statusline = statusline,
            opts = {
                colors = setup_colors,
            }
        }
    end,
}
