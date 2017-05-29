set guioptions-=r  "remove right-hand scroll bar
set guioptions-=L  "remove left-hand scroll bar
set guifont=mononoki:h15
set noballooneval
set laststatus=0

macmenu &File.New\ Tab key=<nop>
map <D-t> :CtrlP<CR>
imap <D-t> <esc>:CtrlP<CR>

macmenu &File.Print key=<nop>
map <D-p> :CtrlPTag<cr>

macmenu &Tools.Make key=<nop>
map <D-b> :exec "Tube " . &makeprg . " && focusvim"<cr>
imap <D-b> <esc>:exec "Tube " . &makeprg . " && focusvim"<cr>

map <D-r> :CtrlPBufTag<cr>

nmap <D-/> :TComment<cr>
vmap <D-/> gc
