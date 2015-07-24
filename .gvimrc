:set guioptions-=r  "remove right-hand scroll bar
:set guioptions-=L  "remove left-hand scroll bar
colorscheme monokai

set guifont=Monaco:h13
set clipboard=unnamed
set showtabline=2

macmenu &Tools.Make key=<nop>
macmenu &File.New\ Window key=<D-S-n>
macmenu &File.New\ Tab key=<D-n>
macmenu &File.Print key=<nop>
macmenu File.Open\ Tab\.\.\. key=<nop>

map <D-t> :CtrlP<CR>
imap <D-t> <ESC>:CtrlP<CR>
nmap <D-/> :TComment<cr>
vmap <D-/> gc
map <D-T> :Undoquit<cr>
nmap <D-Up> <C-]>
nmap <D-Down> :pop<cr>
nmap <C-Left> gT
nmap <C-Right> gt
map <D-F> :call SearchInFiles()<cr>
map <D-r> :NERDTreeFind<cr>

map <ESC> :ccl<cr>
noremap <C-Tab> :tabnext<CR>
noremap <C-S-Tab> :tabprev<CR>
map <D-p> :CtrlPTag<cr>

