vim.g.mapleader = " "

local disabledPlugins = {
  "gzip",
  "zip",
  "zipPlugin",
  "tar",
  "tarPlugin",
  "getscript",
  "getscriptPlugin",
  "vimball",
  "vimballPlugin",
  "2html_plugin",
  "logipat",
  "rrhelper",
  "spellfile_plugin",
}

for _, plugin in pairs(disabledPlugins) do
  vim.g["loaded_" .. plugin] = 1
end

require "plugins"
require("local-rc").load()

-- vim.opt.termguicolors = true
vim.opt.updatetime = 250
vim.opt.spelllang = { "en_US" }
vim.opt.title = true
vim.opt.titlestring = "%f"
vim.opt.laststatus = 3
vim.opt.mouse = "a"
vim.opt.splitright = true
vim.opt.hidden = true
vim.opt.clipboard = "unnamed"
vim.opt.winwidth = 78
vim.opt.virtualedit = "block"
vim.opt.autowriteall = true
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.exrc = true
vim.opt.secure = true
-- vim.opt.cursorline = true

vim.opt.tabstop = 2
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.autoindent = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.foldenable = true
vim.opt.foldlevelstart = 99
vim.opt.foldmethod = "indent"
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.pumheight = 10

vim.opt.tags:append { ".git/tags" } -- " ,~/.rubies/ruby-2.4.6/tags,~/src/ruby-2.4.6/tags
vim.opt.tagcase = "match"

local function best_diagnostic(diagnostics)
  if vim.tbl_isempty(diagnostics) then
    return
  end

  local best_diagnostic = nil
  local line_diagnostics = {}
  local line_nr = vim.api.nvim_win_get_cursor(0)[1] - 1

  for k, v in pairs(diagnostics) do
    if v.lnum == line_nr then
      line_diagnostics[k] = v
    end
  end

  for _, diagnostic in ipairs(line_diagnostics) do
    if best_diagnostic == nil then
      best_diagnostic = diagnostic
    elseif diagnostic.severity < best_diagnostic.severity then
      best_diagnostic = diagnostic
    end
  end

  return best_diagnostic
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

local virt_handler = vim.diagnostic.handlers.virtual_text
local ns = vim.api.nvim_create_namespace "current_line_virt"
local severity = vim.diagnostic.severity
local virt_options = {
  prefix = "",
  format = function(diagnostic)
    if diagnostic.severity == severity.ERROR then
      return signs.Error .. diagnostic.message
    elseif diagnostic.severity == severity.INFO then
      return signs.Info .. diagnostic.message
    elseif diagnostic.severity == severity.WARN then
      return signs.Warn .. diagnostic.message
    elseif diagnostic.severity == severity.HINT then
      return signs.Hint .. diagnostic.message
    else
      return diagnostic.message
    end
  end,
}

vim.diagnostic.handlers.current_line_virt = {
  show = function(_, bufnr, diagnostics, _)
    local diagnostic = best_diagnostic(diagnostics)
    if not diagnostic then
      return
    end

    local filtered_diagnostics = { diagnostic }

    -- vim.diagnostic.handlers.current_line_virt.hide(nil, nil)
    pcall(
      virt_handler.show,
      ns,
      bufnr,
      filtered_diagnostics,
      { virtual_text = virt_options }
    )
  end,
  hide = function(_, bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    virt_handler.hide(ns, bufnr)
  end,
}

vim.diagnostic.config {
  float = { source = "always" },
  signs = false,
  virtual_text = false,
  severity_sort = true,
  current_line_virt = true,
}

vim.cmd [[
  augroup alisnic
    autocmd!
    autocmd BufWritePre * :%s/\s\+$//e
    autocmd FocusGained * checktime
    autocmd FileType gitcommit setlocal spell
    autocmd FileType ruby,haml setlocal tags+=.git/rubytags | setlocal tags-=.git/tags
  augroup END
]]

for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.lsp.handlers["textDocument/formatting"] = function(err, result, ctx)
  local bufnr = ctx["bufnr"]

  if err ~= nil or result == nil then
    return
  end

  if not vim.api.nvim_buf_get_option(bufnr, "modified") then
    local view = vim.fn.winsaveview()

    local client = vim.lsp.get_client_by_id(ctx.client_id)
    vim.lsp.util.apply_text_edits(result, bufnr, client.offset_encoding)

    vim.fn.winrestview(view)
    if bufnr == vim.api.nvim_get_current_buf() then
      vim.api.nvim_command "noautocmd :update"
    end
  end
end

function _G.on_attach_callback(client, bufnr)
  if client.resolved_capabilities.document_formatting then
    vim.api.nvim_command [[augroup Format]]
    vim.api.nvim_command [[autocmd! * <buffer>]]
    vim.api.nvim_command [[autocmd BufWritePost <buffer> lua vim.lsp.buf.formatting()]]
    vim.api.nvim_command [[augroup END]]
  end

  vim.cmd [[
    hi! link DiagnosticVirtualTextHint Comment
    hi! link DiagnosticVirtualTextInfo Comment
    hi! link DiagnosticVirtualTextWarn Comment
    hi! link DiagnosticVirtualTextError Comment
  ]]

  vim.api.nvim_create_augroup("lsp_diagnostic_current_line", {
    clear = false,
  })
  vim.api.nvim_clear_autocmds {
    buffer = bufnr,
    group = "lsp_diagnostic_current_line",
  }
  vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
    group = "lsp_diagnostic_current_line",
    buffer = bufnr,
    callback = function()
      vim.diagnostic.handlers.current_line_virt.show(
        nil,
        0,
        current_line_diagnostics(),
        nil
      )
    end,
  })
  vim.api.nvim_create_autocmd("CursorMoved", {
    group = "lsp_diagnostic_current_line",
    buffer = bufnr,
    callback = function()
      vim.diagnostic.handlers.current_line_virt.hide(nil, nil)
    end,
  })

  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_create_augroup("lsp_document_highlight", {
      clear = false,
    })
    vim.api.nvim_clear_autocmds {
      buffer = bufnr,
      group = "lsp_document_highlight",
    }
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      group = "lsp_document_highlight",
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd("CursorMoved", {
      group = "lsp_document_highlight",
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })
  end
end

vim.keymap.set("n", "<esc><esc>", ":nohlsearch<cr><esc>")
vim.keymap.set("n", "C", ":cclose<cr>")
vim.keymap.set("n", "<S-UP>", "<C-w><UP>")
vim.keymap.set("n", "<S-Down>", "<C-w><Down>")
vim.keymap.set("n", "<S-Left>", "<C-w><Left>")
vim.keymap.set("n", "<S-Right>", "<C-w><Right>")
vim.keymap.set("n", "<UP>", "gk")
vim.keymap.set("n", "<Down>", "gj")
vim.keymap.set("n", "<leader>.", ":e ~/.dotfiles/nvim/lua/plugins.lua<cr>")

vim.keymap.set("v", "<S-UP>", "<nop>")
vim.keymap.set("v", "<S-Down>", "<nop>")

vim.cmd [[command! Scratch :exe "e " . "~/.notes/scratch/" . strftime('%Y-%m-%d') . ".txt"]]
vim.cmd 'command! Focus :exe "normal! zMzv"'
vim.cmd "command! W w"
vim.cmd "command! Wq wq"
