local function best_diagnostic(diagnostics)
  if vim.tbl_isempty(diagnostics) then
    return
  end

  local best = nil
  local line_diagnostics = {}
  local line_nr = vim.api.nvim_win_get_cursor(0)[1] - 1

  for k, v in pairs(diagnostics) do
    if v.lnum == line_nr then
      line_diagnostics[k] = v
    end
  end

  for _, diagnostic in ipairs(line_diagnostics) do
    if best == nil then
      best = diagnostic
    elseif diagnostic.severity < best.severity then
      best = diagnostic
    end
  end

  return best
end

local function current_line_diagnostics()
  local bufnr = 0
  local line_nr = vim.api.nvim_win_get_cursor(0)[1] - 1
  local opts = { ["lnum"] = line_nr }

  return vim.diagnostic.get(bufnr, opts)
end

local signs = {
  Error = " ",
  Warn = " ",
  Hint = " ",
  Info = " ",
}
local severity = vim.diagnostic.severity

local function format_diagnostic(diagnostic)
  local message = vim.split(diagnostic.message, "\n")[1]

  if diagnostic.severity == severity.ERROR then
    return signs.Error .. message
  elseif diagnostic.severity == severity.INFO then
    return signs.Info .. message
  elseif diagnostic.severity == severity.WARN then
    return signs.Warn .. message
  elseif diagnostic.severity == severity.HINT then
    return signs.Hint .. message
  else
    return message
  end
end

vim.diagnostic.config {
  float = { source = "always" },
  signs = false,
  virtual_text = false,
  severity_sort = true,
  update_in_insert = false
}

for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

local util = require "vim.lsp.util"
local api = vim.api
local originalReferenceHandler = vim.lsp.handlers["textDocument/references"]
local log = require "vim.lsp.log"

local function location_handler(_, result, ctx, _)
  if result == nil or vim.tbl_isempty(result) then
    local _ = log.info() and log.info(ctx.method, "No location found")
    return nil
  end
  local client = vim.lsp.get_client_by_id(ctx.client_id)

  if vim.tbl_islist(result) then
    util.jump_to_location(result[1], client.offset_encoding)

    if #result > 1 then
      vim.fn.setloclist(0, {}, " ", {
        title = "LSP locations",
        items = util.locations_to_items(result, client.offset_encoding),
      })
      api.nvim_command "lopen"
    end
  else
    util.jump_to_location(result, client.offset_encoding)
  end
end

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "rounded",
})

vim.lsp.handlers["textDocument/declaration"] = location_handler
vim.lsp.handlers["textDocument/definition"] = location_handler
vim.lsp.handlers["textDocument/typeDefinition"] = location_handler
vim.lsp.handlers["textDocument/implementation"] = location_handler
vim.lsp.handlers["textDocument/references"] = function(hz, result, ctx, _)
  originalReferenceHandler(hz, result, ctx, { loclist = true })
end

function augroup(name, fn)
  vim.api.nvim_create_augroup(name, {
    clear = true,
  })

  return {
    autocmd = function(event, opts)
      opts.group = name
      vim.api.nvim_create_autocmd(event, opts)
    end,
  }
end

function _G.on_attach_callback(client, bufnr)
  vim.cmd [[
    hi! link DiagnosticVirtualTextHint Comment
    hi! link DiagnosticVirtualTextInfo Comment
    hi! link DiagnosticVirtualTextWarn Comment
    hi! link DiagnosticVirtualTextError Comment
  ]]

  if client.name ~= "tsserver" then
    require("lsp-format").on_attach(client)
  end

  if not vim.api.nvim_buf_is_loaded(bufnr) then
    return
  end
end

return {
  format_diagnostic = format_diagnostic,
  current_line_diagnostics = current_line_diagnostics,
  best_diagnostic = best_diagnostic,
}
