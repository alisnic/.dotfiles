set guioptions-=r  "remove right-hand scroll bar
set guioptions-=L  "remove left-hand scroll bar
set guifont=mononoki:h15
set guitablabel=%t
set laststatus=0
set noballooneval
set showtabline=2
set clipboard=unnamed

macmenu &Tools.Make key=<nop>
macmenu &File.Close key=<nop>
macmenu &File.New\ Tab key=<nop>
macmenu &File.Print key=<nop>
macmenu File.Open\ Tab\.\.\. key=<nop>

map <D-t> :CtrlP<CR>
map <D-w> :tabclose<cr>
imap <D-t> <esc>:CtrlP<CR>
imap <D-T> <esc>:CtrlPBuffer<cr>
map <D-T> :CtrlPBuffer<cr>
nmap <D-/> :TComment<cr>
vmap <D-/> gc
nmap <D-F> :tabedit \| Ack<space>
imap <D-F> :tabedit \| Ack<space>
map <D-p> :CtrlPTag<cr>
map <D-b> :exec "Tube " . &makeprg . " && focusvim"<cr>
imap <D-b> <esc>:exec "Tube " . &makeprg . " && focusvim"<cr>
