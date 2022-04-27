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

vim.opt.termguicolors = true
vim.opt.updatetime = 250
vim.opt.spelllang = { "en_US" }
vim.opt.title = true
vim.opt.titlestring = "%f"
vim.opt.laststatus = 0
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

vim.opt.tags:append { ".git/tags" } -- " ,~/.rubies/ruby-2.4.6/tags,~/src/ruby-2.4.6/tags
vim.opt.tagcase = "match"

vim.cmd [[
  augroup alisnic
    autocmd!
    autocmd BufWritePre * :%s/\s\+$//e
    autocmd FocusGained * checktime
    autocmd FileType text setlocal modeline
    autocmd FileType gitcommit setlocal spell
    autocmd FileType ruby,haml setlocal tags+=.git/rubytags | setlocal tags-=.git/tags
    autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})
  augroup END
]]

vim.diagnostic.config { virtual_text = false, source = true }

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

vim.api.nvim_set_keymap(
  "n",
  "<esc><esc>",
  ":nohlsearch<cr><esc>",
  { noremap = true, silent = true }
)

local util = require "util"
util.nmap("<S-UP>", "<C-w><UP>")
util.nmap("<S-Down>", "<C-w><Down>")
util.nmap("<S-Left>", "<C-w><Left>")
util.nmap("<S-Right>", "<C-w><Right>")
util.nmap("<UP>", "gk")
util.nmap("<Down>", "gj")
util.nmap("<leader>.", ":e ~/.dotfiles/nvim<cr>")

util.vmap("<S-UP>", "<nop>")
util.vmap("<S-Down>", "<nop>")

vim.cmd [[command! Scratch :exe "e " . "~/.notes/scratch/" . strftime('%Y-%m-%d') . ".txt"]]
vim.cmd 'command! Focus :exe "normal! zMzv"'
vim.cmd "command! W w"
vim.cmd "command! Wq wq"
