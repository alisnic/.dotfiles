:set guioptions-=r  "remove right-hand scroll bar
:set guioptions-=L  "remove left-hand scroll bar
colorscheme monokai

set guifont=Inconsolata-dz\ for\ Powerline:h14
set clipboard=unnamed

macmenu &Tools.Make key=<nop>
macmenu &File.New\ Window key=<D-S-n>
macmenu &File.New\ Tab key=<D-n>
macmenu &File.Print key=<nop>

map <D-t> :CtrlP<CR>
imap <D-t> <ESC>:CtrlP<CR>
nmap <D-/> :TComment<cr>
vmap <D-/> gc
nmap <D-S-t> :Undoquit<cr>
map <D-\.> :OpenAlternate<cr>
nmap <D-\.> :OpenAlternate<cr>
imap <D-\.> :OpenAlternate<cr>
nmap <D-Up> <C-]>
nmap <D-Down> :pop<cr>
nmap <C-Left> gT
nmap <C-Right> gt

map <ESC> :ccl<cr>
noremap <C-Tab> :tabnext<CR>
noremap <C-S-Tab> :tabprev<CR>
map <D-S-f> :Ack
map <D-p> :CtrlPTag<cr>

