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
  "netrw",
  "netrwPlugin",
}

for _, plugin in pairs(disabledPlugins) do
  vim.g["loaded_" .. plugin] = 1
end

vim.cmd "packadd cfilter"

require "plugins"
require "lsp"
require("local-rc").load()

vim.opt.background = "light"
vim.cmd "colorscheme gruvbox"

-- vim.opt.termguicolors = true
vim.opt.updatetime = 250
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
vim.opt.spelllang = "en"
vim.opt.scrolloff = 5
-- vim.opt.cursorline = true
--
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 2

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

vim.opt.tags:append { ".git/tags" }
vim.opt.tagcase = "match"

vim.cmd [[
  augroup alisnic
    autocmd!
    autocmd BufWritePre * :%s/\s\+$//e
    autocmd FocusGained * checktime
    autocmd FileType gitcommit setlocal spell
    autocmd VimResized * :wincmd =
  augroup END
]]

vim.keymap.set("n", "<esc><esc>", ":nohlsearch<cr><esc>")
vim.keymap.set("n", "C", ":windo lcl|ccl<CR>")
vim.keymap.set("n", "<S-UP>", "<C-w><UP>")
vim.keymap.set("n", "<S-Down>", "<C-w><Down>")
vim.keymap.set("n", "<S-Left>", "<C-w><Left>")
vim.keymap.set("n", "<S-Right>", "<C-w><Right>")
vim.keymap.set("n", "<UP>", "gk")
vim.keymap.set("n", "<Down>", "gj")
vim.keymap.set("n", "<leader>.", ":e ~/.dotfiles/nvim/lua/plugins.lua<cr>")
vim.keymap.set("v", "<S-UP>", "<nop>")
vim.keymap.set("v", "<S-Down>", "<nop>")

-- vim.cmd [[nnoremap d "_d]]
-- vim.cmd [[vnoremap D d]]
-- vim.cmd [[vnoremap d "_d]]
vim.cmd [[command! Scratch :exe "e " . "~/.notes/scratch/" . strftime('%Y-%m-%d') . ".md"]]
vim.cmd 'command! Focus :exe "normal! zMzv"'
vim.cmd "command! W w"
vim.cmd "command! Wq wq"
