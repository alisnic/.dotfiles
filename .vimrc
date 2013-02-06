call pathogen#infect()

filetype plugin indent on
set spell
let spell_auto_type="all"

let g:solarized_termcolors=256
se t_Co=256

syntax enable
set background=light
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
nmap <silent> <S-Up> :wincmd k<CR>
nmap <silent> <S-Down> :wincmd j<CR>
nmap <silent> <S-Left> :wincmd h<CR>
nmap <silent> <S-Right> :wincmd l<CR>

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
