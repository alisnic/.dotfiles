" filetype plugin on
call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-sensible'
Plug 'tomtom/tcomment_vim'
Plug 'AndrewRadev/undoquit.vim'
Plug 'terryma/vim-expand-region'
Plug 'jiangmiao/auto-pairs'
Plug 'cyphactor/vim-open-alternate'
Plug 'tpope/vim-haml'

" Enable tags from ruby gems
Plug 'tpope/vim-bundler'
" Plug 'majutsushi/tagbar'
Plug 'gcmt/tube.vim'

Plug 'FelikZ/ctrlp-py-matcher'
Plug 'kien/ctrlp.vim'
  let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
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
  let g:ctrlp_clear_cache_on_exit=1
  if executable('ag')
    let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
  endif

Plug 'scrooloose/nerdtree'
Plug 'kchmck/vim-coffee-script'
Plug 'tpope/vim-endwise'

let g:ycm_tag_files = []
function! YCM_tagfiles()
  return g:ycm_tag_files
endfunction

Plug 'Valloric/YouCompleteMe'
  let g:ycm_collect_identifiers_from_tags_files = 1
  let g:ycm_min_num_of_chars_for_completion = 3

Plug 'elixir-lang/vim-elixir'
Plug 'tpope/vim-fugitive'
Plug 'sickill/vim-monokai'

Plug 'mileszs/ack.vim'
  let g:ackpreview = 1
  if executable('ag')
    let g:ackprg = 'ag --vimgrep'
  endif

" Plug 'bling/vim-airline'       " UI statusbar niceties
"   set laststatus=2               " enable airline even if no splits
"   let g:airline_theme='base16'
"   let g:airline_left_sep = ''
"   let g:airline_right_sep = ''
"   let g:airline#extensions#tabline#enabled = 0
"   let g:airline#extensions#tagbar#enabled = 1
"   let g:airline_mode_map = {
"         \ 'n' : 'N',
"         \ 'i' : 'I',
"         \ 'R' : 'REPLACE',
"         \ 'v' : 'VISUAL',
"         \ 'V' : 'V-LINE',
"         \ 'c' : 'CMD   ',
"         \ }

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
filetype plugin indent on
colorscheme monokai

set mouse=a
set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
set guitablabel=%t
set list listchars=trail:-,tab:>-
set tags=.git/tags
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
" set cuc
" Searching
set hlsearch
set incsearch
set ignorecase
set smartcase
" Enable per-project vimrcs
set exrc   " enable per-directory .vimrc files
set secure " disable unsafe commands in local .vimrc files
set colorcolumn=80

" Hide the status line
set noshowmode
set noruler
set noshowcmd
set laststatus=0

let $TERM='screen-256color'
let &t_AB="\e[48;5;%dm"
let &t_AF="\e[38;5;%dm"
let mapleader = "\<Space>"

cabbrev st Gstatus
cabbrev cm Gcommit -v
cabbrev ph Git push
cabbrev df Git! diff
cabbrev cpr :silent !cpr
cabbrev te tabedit

autocmd FileType nerdtree nmap <buffer> <left> x
autocmd FileType nerdtree nmap <buffer> <right> <cr>

map <c-c> <esc>
map <C-t> :NERDTreeToggle<cr>
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)
" I don't use macros
nmap q b
nnoremap <esc><esc> :nohlsearch<cr>
map <Tab> gt
nmap <leader>t :CtrlP<cr>
nmap <leader>u :Undoquit<cr>
nmap <leader>w :q<cr>
nmap <leader><left> gT
nmap <leader><right> gt
nmap <leader>a ggVG<cr>
nmap <leader>] <C-]>
nmap <leader>[ :pop<cr>
nmap <leader>d g]
nmap <leader>/ :TComment<cr>
vmap <leader>/ gc
nmap <leader>r :NERDTreeFind<cr>

function! SearchInFiles()
  let query = input('Search in files: ')
  if len(query) == 0
    return
  endif
  exec ":Ack " . query
endfunction
nmap <leader>s :call SearchInFiles()<cr>

function! SearchInTags()
  let query = input('Search in tags: ')
  if len(query) == 0
    return
  endif
  exec ":tselect " . query
endfunction
nmap <leader>p :call SearchInTags()<cr>

nnoremap <leader><leader> :OpenAlternate<cr>
