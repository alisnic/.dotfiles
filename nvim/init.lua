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

vim.opt.termguicolors = true
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

function GetCurrentDiagnostic()
  bufnr = 0
  line_nr = vim.api.nvim_win_get_cursor(0)[1] - 1
  opts = { ["lnum"] = line_nr }

  local line_diagnostics = vim.diagnostic.get(bufnr, opts)
  if vim.tbl_isempty(line_diagnostics) then
    return
  end

  local best_diagnostic = nil

  for _, diagnostic in ipairs(line_diagnostics) do
    if
      best_diagnostic == nil or diagnostic.severity < best_diagnostic.severity
    then
      best_diagnostic = diagnostic
    end
  end

  return best_diagnostic
end

function GetCurrentDiagnosticString()
  local diagnostic = GetCurrentDiagnostic()

  if not diagnostic or not diagnostic.message then
    return
  end

  return diagnostic.message
end

vim.cmd [[
  augroup alisnic
    autocmd!
    autocmd BufWritePre * :%s/\s\+$//e
    autocmd FocusGained * checktime
    autocmd FileType gitcommit setlocal spell
    autocmd FileType ruby,haml setlocal tags+=.git/rubytags | setlocal tags-=.git/tags
  augroup END
]]

vim.diagnostic.config { float = { source = "always" }, virtual_text = false }

local signs = {
  Error = " ",
  Warn = " ",
  Hint = " ",
  Info = " ",
}

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

vim.keymap.set("n", "<esc><esc>", ":nohlsearch<cr><esc>")
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
