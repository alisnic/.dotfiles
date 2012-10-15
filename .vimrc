call pathogen#infect()

let mapleader=","

let g:solarized_termcolors=256
colorscheme solarized
se t_Co=256

set cursorline
set mouse=a
" always show status line
set ls=2

" do not trash the filesystem
set nobackup
set nowritebackup
set noswapfile

" always show tabs
set showtabline=2

" number of spaces for tab character
set tabstop=2

" number of spaces to autoindent
set shiftwidth=2

" convert tabs to spaces
set expandtab

" show trailing whitespace
set list listchars=trail:·,tab:··


map <c-c> <esc>
nnoremap <cr> :nohlsearch<cr>

:command W w

function! OpenTestAlternate()
  let new_file = AlternateForCurrentFile()
  exec ':e ' . new_file
endfunction
function! AlternateForCurrentFile()
  let current_file = expand("%")
  let new_file = current_file
  let in_spec = match(current_file, '^spec/') != -1
  let going_to_spec = !in_spec
  let in_app = match(current_file, '\<controllers\>') != -1 || match(current_file, '\<models\>') != -1 || match(current_file, '\<views\>') != -1 || match(current_file, '\<helpers\>') != -1
  if going_to_spec
    if in_app
      let new_file = substitute(new_file, '^app/', '', '')
    end
    let new_file = substitute(new_file, '\.rb$', '_spec.rb', '')
    let new_file = 'spec/' . new_file
  else
    let new_file = substitute(new_file, '_spec\.rb$', '.rb', '')
    let new_file = substitute(new_file, '^spec/', '', '')
    if in_app
      let new_file = 'app/' . new_file
    end
  endif
  return new_file
endfunction
nnoremap <leader>. :call OpenTestAlternate()<cr>
