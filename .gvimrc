set guioptions-=r  "remove right-hand scroll bar
set guioptions-=L  "remove left-hand scroll bar
set guifont=mononoki:h15
set noballooneval
set balloonexpr=
set laststatus=0
set mouse=a

macmenu &File.New\ Tab key=<nop>
noremap <D-t> :CtrlPMixed<CR>
inoremap <D-t> <esc>:CtrlP<CR>

macmenu &File.Print key=<nop>
noremap <D-p> :CtrlPTag<cr>

noremap <D-r> :CtrlPBufTag<cr>

" Resize window to fit the entire screen after closing penultimate tab
autocmd TabClosed * set lines=50 columns=179
