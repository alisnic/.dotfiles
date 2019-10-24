set guioptions-=r  "remove right-hand scroll bar
set guioptions-=L  "remove left-hand scroll bar
set guifont=Monaco:h14
set laststatus=0
set showtabline=2
set background=dark
set shell=$SHELL\ -l

macmenu &File.New\ Tab key=<nop>
noremap <D-t> :tab terminal<cr>

nnoremap <leader>t :exec("tab term " . &makeprg)<cr>
nnoremap <leader>l :exec("tab term " . &makeprg . ":" . line('.'))<cr>

tmap <D-w> <C-d>
tmap <ScrollWheelDown> <C-W>N
tmap <ScrollWheelUp> <C-W>N

tmap <D-]> <C-W>N:tabn<cr>
tmap <D-[> <C-W>N:tabp<cr>
nnoremap <D-]> :tabn<cr>
nnoremap <D-[> :tabp<cr>
