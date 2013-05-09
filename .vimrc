set nocompatible               " be iMproved
filetype off                   " required!

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'
Bundle 'kien/ctrlp.vim'
Bundle 'altercation/vim-colors-solarized'
Bundle 'Lokaltog/vim-powerline'
Bundle 'scrooloose/nerdtree'
Bundle 'Valloric/YouCompleteMe'
Bundle 'kchmck/vim-coffee-script'
Bundle 'tpope/vim-endwise'
Bundle 'tpope/vim-markdown'
"Bundle 'tpope/vim-rails'
"Bundle 'vimspell'

set guioptions-=T
set guioptions+=c

filetype on
filetype indent on
filetype plugin on
set spell
let spell_auto_type="all"

let g:solarized_termcolors=256
se t_Co=256

syntax enable
set background=light
colorscheme solarized
set colorcolumn=80

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

" Jump to last cursor position unless it's invalid or in an event handler
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal g`\"" |
  \ endif

"
" SHORTCUTS
"
let mapleader=","

" Disable some keys
inoremap <PageUp>   <NOP>
inoremap <PageDown>  <NOP>
nnoremap <PageUp>  <NOP>
nnoremap <PageDown> <NOP>

nnoremap <leader>v :vsp<cr>
nnoremap <leader>h :sp<cr>
nnoremap <leader>s :w<cr>

" Run hotkeys
function RunWith (command)
  execute "w"
  execute "!clear;time " . a:command . " " . expand("%")
endfunction

function! RSpecCurrent()
  execute("!clear && rspec " . expand("%p") . ":" . line(".") . " --color")
endfunction

autocmd FileType coffee   nmap <F5> :call RunWith("coffee")<cr>
autocmd FileType ruby     nmap <F5> :call RunWith("ruby")<cr>
autocmd FileType clojure  nmap <F5> :call RunWith("clj")<cr>
autocmd BufRead *_spec.rb nmap <F6> :w\|!clear && rspec % --format documentation --color<cr>
autocmd BufRead *_spec.rb nmap <F7> :call RSpecCurrent()<CR>

" do not press shift to enter command
map ; :
map <c-f> /
"copy to X clipboard
map <leader>cc :w !xsel -i -b<CR>
" swap words
nnoremap <silent> gw "_yiw:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR><c-o><c-l>
map <c-c> <esc>
nnoremap <cr> :nohlsearch<cr>
nnoremap <leader>t :NERDTreeToggle<cr>
:command W w
"insert hashrocket
imap <c-l> <Space>=><Space>
nnoremap <leader>p :set paste!<cr>


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
