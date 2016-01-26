function! TermSpec()
  exec "!bin/spring rspec " . expand('%:p')
endfunction

nmap <leader>b :call TermSpec()<cr>
let g:ycm_tags = [".git/tags"]
cscope add .git/cscope.out
