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

vim.lsp.handlers["textDocument/publishDiagnostics"] =
  vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    -- delay update diagnostics
    update_in_insert = false,
  })

return {
  format_diagnostic = format_diagnostic,
  current_line_diagnostics = current_line_diagnostics,
  best_diagnostic = best_diagnostic,
}
