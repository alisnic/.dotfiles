set guioptions-=r  "remove right-hand scroll bar
set guioptions-=L  "remove left-hand scroll bar
set guifont=mononoki:h15
set guitablabel=%t
set clipboard=unnamed
set laststatus=0
set mouse=a
set noballooneval
set balloonexpr=
set showtabline=2
set ruler

au TabLeave * silent! wall

hi MatchParen guibg=lightgrey guifg=NONE

macmenu &Tools.Make key=<nop>
macmenu &File.Close key=<nop>
macmenu &File.New\ Window key=<D-S-n>
macmenu &File.New\ Tab key=<D-n>
macmenu &File.Print key=<nop>
macmenu File.Open\ Tab\.\.\. key=<nop>
macmenu Window.Select\ Next\ Tab key=<nop>
macmenu Window.Select\ Previous\ Tab key=<nop>

map <D-t> :CtrlP<CR>
map <D-r> :CtrlPBufTag<CR>
map <D-w> :tabclose<cr>
imap <D-t> <ESC>:CtrlP<CR>
imap <D-T> :tabnew#<cr>
nmap <D-/> :TComment<cr>
vmap <D-/> gc
map <D-F> :call SearchInFiles()<cr>
imap <D-F> :call SearchInFiles()<cr>
map <D-p> :CtrlPTag<cr>
map <D-b> :exec "w \| Tube " . &makeprg . " && focusvim"<cr>
imap <D-b> <esc>:exec "w \| Tube " . &makeprg . " && focusvim"<cr>

" Tab navigation
nmap <D-]> gt
imap <D-]> <esc>gt
nmap <D-[> gT
imap <D-[> <esc>gT

