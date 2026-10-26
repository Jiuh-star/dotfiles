local api = vim.api
local ts = vim.treesitter

local LEFT, RIGHT = "", ""

---@alias FoldtextChunk { [1]: string, [2]: string|string[] }

---@class FoldtextCache
---@field tick integer
---@field ft string
---@field lines table<integer, FoldtextChunk[]>

---@type table<integer, FoldtextCache>
local cache = {}

local M = {}

---Collect the highlight chunks that cover one line.
---@param bufnr integer
---@param lnum integer 1-based line number
---@param query vim.treesitter.Query
---@param root TSNode
---@return FoldtextChunk[]?
local function build_chunks(bufnr, lnum, query, root)
  local line = api.nvim_buf_get_lines(bufnr, lnum - 1, lnum, false)[1]
  if not line then return end

  local row = lnum - 1

  -- Captures fully contained on this line, and the columns that split them.
  local captures, cuts = {}, { [0] = true, [#line] = true }
  for id, node, metadata in query:iter_captures(root, bufnr, row, row + 1) do
    local srow, scol, erow, ecol = node:range()
    if srow == row and erow == row and ecol > scol then
      captures[#captures + 1] = {
        from = scol,
        to = ecol,
        hl = "@" .. query.captures[id],
        priority = tonumber(metadata.priority) or vim.highlight.priorities.treesitter,
      }
      cuts[scol], cuts[ecol] = true, true
    end
  end

  -- Split the line at every capture boundary. Each resulting chunk is covered
  -- by a fixed set of captures, so the chunks never overlap.
  local points = vim.tbl_keys(cuts)
  table.sort(points)

  local chunks = {}
  for i = 1, #points - 1 do
    local from, to = points[i], points[i + 1]

    -- All captures covering this chunk.
    local groups = vim.tbl_filter(function(c) return c.from <= from and c.to >= to end, captures)

    -- Ancestors first, children and higher-priority captures last (they win).
    table.sort(groups, function(a, b)
      if a.priority ~= b.priority then return a.priority < b.priority end
      return a.to - a.from > b.to - b.from
    end)

    local hl = vim.tbl_map(function(c) return c.hl end, groups)

    chunks[#chunks + 1] = { line:sub(from + 1, to), #hl > 0 and hl or "Folded" }
  end

  return chunks
end

---Highlight chunks for one line, cached by buffer revision.
---@param bufnr integer
---@param lnum integer
---@return FoldtextChunk[]?
local function line_chunks(bufnr, lnum)
  local entry = cache[bufnr]
  local tick = vim.b[bufnr].changedtick
  local ft = vim.bo[bufnr].filetype
  if not entry or entry.tick ~= tick or entry.ft ~= ft then
    entry = { tick = tick, ft = ft, lines = {} }
    cache[bufnr] = entry
  end

  local cached = entry.lines[lnum]
  if cached then return cached end

  local parser = ts.get_parser(bufnr)
  if not parser then return end

  local query = ts.query.get(parser:lang(), "highlights")
  if not query then return end

  local row = lnum - 1
  local tree = parser:parse({ row, row + 1 })[1]
  if not tree then return end

  local chunks = build_chunks(bufnr, lnum, query, tree:root())
  if chunks then entry.lines[lnum] = chunks end
  return chunks
end

---@param hidden integer
---@return FoldtextChunk[]
local function badge(hidden)
  if hidden < 1 then return { { " ", "Folded" } } end

  local unit = hidden == 1 and " line" or " lines"
  return {
    { " " .. LEFT, "FoldedIcon" },
    { "+" .. hidden .. unit, "FoldedText" },
    { RIGHT .. " ", "FoldedIcon" },
  }
end

---@return FoldtextChunk[]|string
local function render()
  local bufnr = api.nvim_get_current_buf()
  local start = vim.v.foldstart
  local head = line_chunks(bufnr, start)
  if not head then return vim.fn.foldtext() end

  local result = vim.list_extend({}, head)
  vim.list_extend(result, badge(vim.v.foldend - start - 1))

  if vim.v.foldend > start then
    local tail = line_chunks(bufnr, vim.v.foldend)
    if tail and tail[1] then
      result[#result + 1] = { vim.trim(tail[1][1]), tail[1][2] }
      vim.list_extend(result, tail, 2)
    end
  end

  return result
end

---'foldtext' entry point.
---@return FoldtextChunk[]|string
function M.foldtext()
  local ok, result = pcall(render)
  if not ok or not result then return vim.fn.foldtext() end
  return result
end

local function set_fold_hl()
  local float = api.nvim_get_hl(0, { name = "NormalFloat", link = false })
  local comment = api.nvim_get_hl(0, { name = "Comment", link = false })
  local folded = api.nvim_get_hl(0, { name = "Folded", link = false })
  api.nvim_set_hl(0, "FoldedIcon", { fg = float.bg })
  api.nvim_set_hl(0, "FoldedText", { bg = float.bg, fg = comment.fg, italic = true })
  api.nvim_set_hl(0, "Folded", { fg = folded.fg })
end

function M.setup()
  local augroup = api.nvim_create_augroup("Foldtext", { clear = true })
  set_fold_hl()

  api.nvim_create_autocmd("ColorScheme", { group = augroup, callback = set_fold_hl })
  api.nvim_create_autocmd("BufWipeout", {
    group = augroup,
    callback = function(args) cache[tonumber(args.buf)] = nil end,
  })

  vim.o.foldtext = 'v:lua.require("lib.foldtext").foldtext()'
end

return M
