set guioptions-=r  "remove right-hand scroll bar
set guioptions-=L  "remove left-hand scroll bar
set guifont=mononoki:h15
set noballooneval
set laststatus=0

macmenu &File.New\ Tab key=<nop>
noremap <D-t> :CtrlPMixed<CR>
inoremap <D-t> <esc>:CtrlP<CR>

macmenu &File.Print key=<nop>
noremap <D-p> :CtrlPTag<cr>

macmenu &Tools.Make key=<nop>
noremap <D-b> :exec "Tube " . &makeprg . " && focusvim"<cr>
inoremap <D-b> <esc>:exec "Tube " . &makeprg . " && focusvim"<cr>

noremap <D-r> :CtrlPBufTag<cr>
