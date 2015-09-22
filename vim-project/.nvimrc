map <D-b> :Tube bin/spring rspec % && focusvim<cr>
" nmap b :!bin/spring rspec %
function! TermSpec()
  exec "tabedit | call termopen('bin/spring rspec " . expand('%:p') . "') | startinsert"
endfunction

nmap <leader>b :call TermSpec()<cr>
let g:ycm_tags = [".git/tags"]
