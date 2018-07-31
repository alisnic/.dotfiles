set guioptions-=r  "remove right-hand scroll bar
set guioptions-=L  "remove left-hand scroll bar
set guioptions-=e  "do not use native tabs
set guifont=Monaco:h14
set laststatus=0

macmenu &File.New\ Tab key=<nop>
noremap <D-t> :CtrlPMixed<CR>
inoremap <D-t> <esc>:CtrlP<CR>

macmenu &File.Print key=<nop>
noremap <D-p> :CtrlPTag<cr>

noremap <D-r> :CtrlPBufTag<cr>

" Resize window to fit the entire screen after closing penultimate tab
autocmd TabClosed * set lines=50 columns=179
