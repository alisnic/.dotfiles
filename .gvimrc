:set guioptions-=r  "remove right-hand scroll bar
:set guioptions-=L  "remove left-hand scroll bar

set guifont=Monaco:h13
set clipboard=unnamed
set showtabline=2
set laststatus=0
set mouse=a

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
nmap <D-/> :TComment<cr>
vmap <D-/> gc
nmap <C-Left> gT
nmap <C-Right> gt
nmap <C-Up> [m
nmap <C-Down> ]m
map <D-F> :call SearchInFiles()<cr>
map <D-]> <C-]>
map <D-}> <C-w><C-]><C-w>T
map <D-[> :pop<cr>

map <ESC> :ccl<cr>
map <D-p> :CtrlPTag<cr>

