:set guioptions-=r  "remove right-hand scroll bar
:set guioptions-=L  "remove left-hand scroll bar
colorscheme monokai
set guifont=Inconsolata-dz\ for\ Powerline:h14

macmenu &Tools.Make key=<nop>
macmenu &File.New\ Window key=<D-S-n>
macmenu &File.New\ Tab key=<D-n>
macmenu &File.Print key=<nop>

map <D-t> :CtrlP<CR>
imap <D-t> <ESC>:CtrlP<CR>
map <ESC> :ccl<cr>
imap <ESC> :ccl<cr>
noremap <C-Tab> :tabnext<CR>
noremap <C-S-Tab> :tabprev<CR>
map <leader>. :call OpenTestAlternate()<cr>
map <D-S-f> :Ack
map <D-p> :CtrlPTag<cr>

autocmd BufRead *_spec.rb noremap <D-b> :w\|:Dispatch bin/spring rspec %<cr>

