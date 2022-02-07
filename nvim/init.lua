vim.g.mapleader = " "
require('plugins')

vim.opt.title=true
vim.opt.titlestring='%f'
vim.opt.laststatus=0
vim.opt.mouse='a'
vim.opt.splitright = true
vim.opt.hidden = true
vim.opt.clipboard='unnamed'
vim.opt.winwidth=78
vim.opt.virtualedit='block'
vim.opt.autowriteall = true
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.exrc = true
vim.opt.secure = true

vim.opt.tabstop=2
vim.opt.expandtab=true
vim.opt.shiftwidth=2
vim.opt.autoindent=true

vim.opt.ignorecase=true
vim.opt.smartcase=true

vim.opt.foldenable=true
vim.opt.foldlevelstart=99
vim.opt.foldmethod='indent'

-- set tags+=.git/tags " ,~/.rubies/ruby-2.4.6/tags,~/src/ruby-2.4.6/tags
-- set tagcase=match
-- nnoremap <leader>] :exec("tabedit \| tag ".expand("<cword>"))<CR>

vim.cmd([[
  augroup alisnic
    autocmd!
    autocmd BufWritePre * :%s/\s\+$//e
    autocmd FocusGained * checktime
    autocmd FileType text setlocal modeline
    autocmd FileType ruby,haml setlocal tags+=.git/rubytags | setlocal tags-=.git/tags
  augroup END
]])

local function nmap(key, cmd)
  vim.api.nvim_set_keymap('n', key, cmd, { noremap = true })
end

local function vmap(key, cmd)
  vim.api.nvim_set_keymap('v', key, cmd, { noremap = true })
end

vim.api.nvim_set_keymap('n', '<esc><esc>', ':nohlsearch<cr><esc>', { noremap = true, silent = true })
nmap('<S-UP>', '<C-w><UP>')
nmap('<S-Down>', '<C-w><Down>')
nmap('<S-Left>', '<C-w><Left>')
nmap('<S-Right>', '<C-w><Right>')
nmap('<leader>1', '1gt')
nmap('<leader>2', '2gt')
nmap('<leader>3', '3gt')
nmap('<UP>', 'gk')
nmap('<Down>', 'gj')

vmap('<S-UP>', '<nop>')
vmap('<S-Down>', '<nop>')
--
-- command! Scratch :exe "e " . "~/.notes/scratch/" . strftime('%Y-%m-%d') . ".txt"
-- command! Focus :exe "normal! zMzv"

-- command! W w
-- command! Wq wq

vim.lsp.handlers["textDocument/formatting"] = function(err, result, ctx)
  local bufnr = ctx['bufnr']

  if err ~= nil or result == nil then
      return
  end
  if not vim.api.nvim_buf_get_option(bufnr, "modified") then
      local view = vim.fn.winsaveview()
      vim.lsp.util.apply_text_edits(result, bufnr)
      vim.fn.winrestview(view)
      if bufnr == vim.api.nvim_get_current_buf() then
          vim.api.nvim_command("noautocmd :update")
      end
  end
end
