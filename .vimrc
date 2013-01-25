call pathogen#infect()

filetype plugin indent on
set spell
let spell_auto_type="all"

let g:solarized_termcolors=256
se t_Co=256

syntax enable
set background=dark
colorscheme solarized

"
" MISC SETTINGS
"
" allow unsaved background buffers and remember marks/undo for them
set hidden
set cursorline
set mouse=a
" always show status line
set ls=2
" show line numbers
set nu
" minimal window width
set winwidth=80
" no junk in filesystem
set nobackup
set nowritebackup
set noswapfile
" always show tabs
set showtabline=2
set autoindent
set tabstop=2
" number of spaces to autoindent
set shiftwidth=2
" convert tabs to spaces
set expandtab
" show trailing whitespace
set list listchars=trail:·,tab:··


"
" SHORTCUTS
"
let mapleader=","
" run commands
map ,rs :w\|!clear && rspec % --format documentation --color<cr>
map ,rr :w\|!clear && ruby %<cr>
" run current rspec example
function! RSpecCurrent()
    execute("!clear && rspec " . expand("%p") . ":" . line(".") . " --color")
  endfunction
  map <leader>rsc :call RSpecCurrent() <CR>
" do not press shift to enter command
map ; :
map <c-f> /
"copy to X clipboard
map <leader>cc :w !xsel -i -b<CR>
" swap words
nnoremap <silent> gw "_yiw:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR><c-o><c-l>
map <c-c> <esc>
nnoremap <cr> :nohlsearch<cr>
:command W w
"insert hashrocket
imap <c-l> <Space>=><Space>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MULTIPURPOSE TAB KEY
" Indent if we're at the beginning of a line. Else, do completion.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>
inoremap <s-tab> <c-n>


"
" Alternate between spec and file
"
function! OpenTestAlternate()
  let new_file = AlternateForCurrentFile()
  exec ':e ' . new_file
endfunction
function! AlternateForCurrentFile()
  let current_file = expand("%")
  let new_file = current_file
  let in_spec = match(current_file, '^spec/') != -1
  let going_to_spec = !in_spec
  let in_app = match(current_file, '\<controllers\>') != -1 || match(current_file, '\<models\>') != -1 || match(current_file, '\<views\>') != -1 || match(current_file, '\<helpers\>') != -1 || match(current_file, '\<domain\>') != -1
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

" Jump to last cursor position unless it's invalid or in an event handler
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal g`\"" |
  \ endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RENAME CURRENT FILE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! RenameFile()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'), 'file')
    if new_name != '' && new_name != old_name
        exec ':saveas ' . new_name
        exec ':silent !rm ' . old_name
        redraw!
    endif
endfunction
map <leader>n :call RenameFile()<cr>
