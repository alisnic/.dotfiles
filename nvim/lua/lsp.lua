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
  update_in_insert = false,
}

for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

local log = vim.lsp.log

local function location_handler(_, result, ctx, config)
  if result == nil or vim.tbl_isempty(result) then
    local _ = log.info() and log.info(ctx.method, 'No location found')
    return nil
  end
  local client = vim.lsp.get_client_by_id(ctx.client_id)

  config = config or {}

  if vim.tbl_islist(result) then
    if #result == 1 then
      vim.lsp.util.jump_to_location(result[1], client.offset_encoding, config.reuse_win)
      return
    end

    local title = 'LSP locations'
    local items = vim.lsp.util.locations_to_items(result, client.offset_encoding)

    vim.fn.setloclist(0, {}, ' ', { title = title, items = items })
    vim.api.nvim_command('lopen')
  else
    vim.lsp.util.jump_to_location(result, client.offset_encoding, config.reuse_win)
  end
end

local handlers = {
  "textDocument/declaration",
  "textDocument/definition",
  "textDocument/typeDefinition",
  "textDocument/implementation",
  "textDocument/references",
}

for i, name in ipairs(handlers) do
  vim.lsp.handlers[name] = location_handler
end

function _G.on_attach_callback(client, bufnr)
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
