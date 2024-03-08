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

local function lsp_diagnostic_status()
  local diagnostics = current_line_diagnostics()
  local best = best_diagnostic(diagnostics)
  local message = format_diagnostic(best)
  local max_width = vim.api.nvim_list_uis()[1].width - 35

  if string.len(message) < max_width then
    return message
  else
    return string.sub(message, 1, max_width) .. "..."
  end
end

return {
  setup = function()
    require("lsp-progress").setup()

    require("lualine").setup {
      options = {
        theme = "gruvbox",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = {},
        lualine_c = {
          {
            lsp_diagnostic_status,
          },
        },
        lualine_x = {
          require("lsp-progress").progress,
        },
        lualine_y = {
          "filename",
          "diagnostics",
        },
        lualine_z = { "location" },
      },
    }

    vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
    vim.api.nvim_create_autocmd("User", {
      group = "lualine_augroup",
      pattern = "LspProgressStatusUpdated",
      callback = require("lualine").refresh,
    })
  end,
}
