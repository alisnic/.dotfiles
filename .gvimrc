set guioptions-=r  "remove right-hand scroll bar
set guioptions-=L  "remove left-hand scroll bar
set guifont=mononoki:h15
set laststatus=0
set noballooneval
set showtabline=2
set clipboard=unnamed

macmenu &File.Close key=<nop>
map <D-w> :tabclose<cr>

macmenu &File.New\ Tab key=<nop>
map <D-t> :CtrlP<CR>
imap <D-t> <esc>:CtrlP<CR>

macmenu &File.Print key=<nop>
map <D-p> :CtrlPTag<cr>

macmenu &Edit.Find.Find\ Next key=<nop>
map <D-g> :CtrlPBuffer<cr>

macmenu &Tools.Make key=<nop>
map <D-b> :exec "Tube " . &makeprg . " && focusvim"<cr>
imap <D-b> <esc>:exec "Tube " . &makeprg . " && focusvim"<cr>

nmap <D-/> :TComment<cr>
vmap <D-/> gc
nmap <D-F> :tabedit \| Ack<space>
imap <D-F> :tabedit \| Ack<space>
