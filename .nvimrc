filetype plugin on
call plug#begin('~/.nvim/plugged')

Plug 'gmarik/vundle'
Plug 'tpope/vim-sensible'
Plug 'kassio/neoterm'
Plug 'tomtom/tcomment_vim'
Plug 'AndrewRadev/undoquit.vim'

Plug 'kien/ctrlp.vim'
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
  let g:ctrlp_mru_files = 1              " Enable Most Recently Used files feature
  let g:ctrlp_jump_to_buffer = 2         " Jump to tab AND buffer if already open
  let g:ctrlp_clear_cache_on_exit=0
  if executable('ag')
    let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
  endif

Plug 'scrooloose/nerdtree'
Plug 'kchmck/vim-coffee-script'
Plug 'tpope/vim-endwise'
Plug 'Valloric/YouCompleteMe'
  let g:ycm_collect_identifiers_from_tags_files = 1

Plug 'elixir-lang/vim-elixir'
Plug 'tpope/vim-fugitive'
Plug 'sickill/vim-monokai'

Plug 'mileszs/ack.vim'
  let g:ackpreview = 1
  if executable('ag')
    let g:ackprg = 'ag --vimgrep'
  endif

Plug 'bling/vim-airline'       " UI statusbar niceties
  set laststatus=2               " enable airline even if no splits
  let g:airline_theme='base16'
  let g:airline_left_sep = ''
  let g:airline_right_sep = ''
  let g:airline#extensions#tabline#enabled = 0
  let g:airline_mode_map = {
        \ 'n' : 'N',
        \ 'i' : 'I',
        \ 'R' : 'REPLACE',
        \ 'v' : 'VISUAL',
        \ 'V' : 'V-LINE',
        \ 'c' : 'CMD   ',
        \ }

call plug#end()

au BufRead,BufNewFile *.hamlc set ft=haml
" Open files where we left off
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
        \| exe "normal! g'\"" | endif
endif
" Delete trailing spaces on save
autocmd BufWritePre * :%s/\s\+$//e

se t_Co=256
syntax enable
colorscheme monokai

set list listchars=trail:-,tab:>-
set tags=.git/tags,.git/gemtags,.tags
set backspace=indent,eol,start
set enc=utf-8
set nobackup
set nowritebackup
set noswapfile
set tabstop=2
set expandtab
set shiftwidth=2
set nu
set clipboard+=unnamedplus
set t_ut= " improve screen clearing by using the background color
set cul
set cuc
" Searching
set hlsearch
set incsearch
set ignorecase
set smartcase
" Enable per-project vimrcs
set exrc   " enable per-directory .vimrc files
set secure " disable unsafe commands in local .vimrc files
set colorcolumn=80

let $TERM='screen-256color'
let &t_AB="\e[48;5;%dm"
let &t_AF="\e[38;5;%dm"
let mapleader = "\<Space>"

cabbrev st Gstatus
"TODO: find a way to silently push, but show output
"cabbrev ph term git push
cabbrev cpr :silent !cpr
cabbrev te tabedit

map <c-c> <esc>
map <C-t> :NERDTreeToggle<cr>
" I don't use macros
nmap q b
nnoremap <esc><esc> :nohlsearch<cr>
map <Tab> gt
tnoremap <esc><esc> <C-\><C-n>
nmap <leader>t :CtrlP<cr>
nmap <leader>u :Undoquit<cr>

function! SearchInFiles()
  let query = input('Enter query: ')
  exec ":Ack " . query
endfunction
nmap <leader>s :call SearchInFiles()<cr>

function! MoveToTabOnLeft()
    let curtab = tabpagenr()
    let tabonleft = curtab - 1
    exe tabonleft."tabnext"
endfunction

augroup tabonleft
    au!
    au TabClosed * call MoveToTabOnLeft()
augroup END

function! OpenTestAlternate()
  let new_file = AlternateForCurrentFile()
  exec ':tab drop ' . new_file
endfunction

function! AlternateForCurrentFile()
  let current_file = expand("%")
  let in_spec = match(current_file, '_spec') != -1

  if in_spec
    return system("find-spec-target " . current_file)
  else
    return system("find-spec " . current_file)
  endif
endfunction
nnoremap <leader>. :call OpenTestAlternate()<cr>
