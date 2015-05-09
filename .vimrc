scriptencoding utf-8
set nocompatible               " be iMproved
filetype off                   " required!

set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#begin()

Plugin 'gmarik/vundle'
Plugin 'kien/ctrlp.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'kchmck/vim-coffee-script'
Plugin 'bling/vim-airline'
Plugin 'tpope/vim-endwise'
Plugin 'tpope/vim-jdaddy'
Plugin 'Valloric/YouCompleteMe'
Plugin 'mileszs/ack.vim'
Plugin 'elixir-lang/vim-elixir'
Plugin 'tpope/vim-dispatch'
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'
Plugin 'scrooloose/syntastic'
Plugin 'majutsushi/tagbar'

call vundle#end()            " required
filetype plugin indent on

au BufRead,BufNewFile *.hamlc set ft=haml
autocmd FileType elixir set nospell

se t_Co=256
color monokai
syntax enable
"set background=dark

"
" MISC SETTINGS
"
set tags=.git/tags,.git/gemtags,.tags
set spell
set colorcolumn=80
set noshowmode
set visualbell
set t_vb=
set nu
set sm!
set cursorline
set clipboard=unnamed
set hlsearch
set smartcase
set ttyfast
set lazyredraw
" allow unsaved background buffers and remember marks/undo for them
set hidden
set laststatus=2
set mouse=a
set winwidth=80
set nobackup
set nowritebackup
set noswapfile
set autoindent
set tabstop=2
set shiftwidth=2
set expandtab
set list listchars=trail:-,tab:>-
set backspace=2

let g:NERDTreeDirArrows=0
let g:nerdtree_tabs_open_on_gui_startup = 0
let g:airline_powerline_fonts = 1
let g:ycm_collect_identifiers_from_tags_files = 1
let spell_auto_type="all"

let g:tagbar_type_ruby = {
    \ 'kinds' : [
        \ 'm:modules',
        \ 'c:classes',
        \ 'd:describes',
        \ 'C:contexts',
        \ 'f:methods',
        \ 'F:singleton methods'
    \ ]
    \ }

let g:ctrlp_prompt_mappings = {
    \ 'AcceptSelection("e")': ['<c-t>'],
    \ 'AcceptSelection("t")': ['<cr>', '<2-LeftMouse>'],
    \ }

let ctrlp_filter_greps = "".
    \ "egrep -iv '\\.(" .
    \ "jar|class|swp|swo|log|so|o|pyc|jpe?g|png|gif|mo|po" .
    \ ")$' | " .
    \ "egrep -v '^(\\./)?(" .
    \ ".git/|.hg/|.svn/" .
    \ ")'"

let my_ctrlp_git_command = "" .
    \ "cd %s && git ls-files | " .
    \ ctrlp_filter_greps

if has("unix")
    let my_ctrlp_user_command = "" .
    \ "find %s '(' -type f -or -type l ')' -maxdepth 15 -not -path '*/\\.*/*' | " .
    \ ctrlp_filter_greps
endif

let g:ctrlp_user_command = ['.git/', my_ctrlp_git_command, my_ctrlp_user_command]

" Jump to last cursor position unless it's invalid or in an event handler
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal g`\"" |
  \ endif

" Delete trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

"
" SHORTCUTS
"
let mapleader=","
nnoremap <leader>v :vsp<cr>
nnoremap <leader>h :sp<cr>
nmap <Tab> <c-w><c-w>
nmap <S-Tab> <c-w><s-w>
cabbrev st Gstatus
cabbrev cm Gcommit
cabbrev ph Dispatch git push
cabbrev df Gdiff

" Run hotkeys
function RunWith (command)
  execute "w"
  execute "!clear;time " . a:command . " " . expand("%")
endfunction

function! RSpecCurrent()
  execute("!clear && bundle exec rspec " . expand("%p") . ":" . line(".") . " --color")
endfunction

autocmd FileType coffee   nmap <f5> :call RunWith("coffee")<cr>
autocmd FileType ruby     nmap <f5> :call RunWith("ruby")<cr>
autocmd FileType clojure  nmap <f5> :call RunWith("clj")<cr>
autocmd BufRead *.js      nmap <f6> :w\|!clear && jslint %<cr>
autocmd BufRead *_test.exs nmap <f6> :w\|!mix test %<cr>
autocmd BufRead *_spec.rb nmap <leader>b :w\|!clear && bundle exec spring rspec % --format documentation --color<cr>
autocmd BufRead *_spec.rb nmap <f7> :call RSpecCurrent()<CR>

" do not press shift to enter command
map ; :
" swap words
nnoremap <silent> gw "_yiw:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR><c-o><c-l>
map <c-c> <esc>
map <c-f> ":Ack "
"nnoremap <cr> :nohlsearch<cr>
map <C-t> :NERDTreeToggle<cr>
:command W w
:command Te tabedit

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
map <leader>r :call RenameFile()<cr>


function! OpenTestAlternate()
  let new_file = AlternateForCurrentFile()
  exec ':tab drop ' . new_file
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
    let new_file = substitute(new_file, '\.e\?rb$', '_spec.rb', '')
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

au FileType qf call AdjustWindowHeight(3, 20)
function! AdjustWindowHeight(minheight, maxheight)
  exe max([min([line("$"), a:maxheight]), a:minheight]) . "wincmd _"
endfunction
