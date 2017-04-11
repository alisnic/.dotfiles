let mapleader = "\<Space>"

call plug#begin('~/.vim/plugged')

let g:loaded_matchit = 1
Plug 'tpope/vim-sensible'
Plug 'altercation/vim-colors-solarized'
Plug 'godlygeek/tabular'
Plug 'jszakmeister/vim-togglecursor'
Plug 'bogado/file-line'
Plug 'Raimondi/delimitMate'
Plug 'tpope/vim-fugitive'

" Language support
Plug 'moll/vim-node'
Plug 'tpope/vim-haml'
Plug 'kchmck/vim-coffee-script'
Plug 'pangloss/vim-javascript'
Plug 'elzr/vim-json'
  let g:vim_json_syntax_conceal = 0

Plug 'tpope/vim-endwise'
Plug 'vim-ruby/vim-ruby'
  let g:no_ruby_maps = 1
  let g:ruby_indent_access_modifier_style = 'outdent'
  let g:ruby_indent_assignment_style = 'variable'
  autocmd FileType ruby setlocal indentkeys-=.

Plug 'tpope/vim-projectionist'
  nnoremap <leader><leader> :AV<cr>

Plug 'neomake/neomake'
  let g:neomake_verbose = 0
  let g:neomake_javascript_enabled_makers = ['eslint']
  autocmd BufRead,BufWrite *.coffee,*.rb,*.js Neomake

Plug 'tomtom/tcomment_vim'
  nmap <leader>/ :TComment<cr>
  vmap <leader>/ gc

Plug 'rhysd/devdocs.vim'
  cabbrev doc DevDocs

Plug 'scrooloose/nerdtree'
  nmap <leader>s :NERDTreeToggle<cr>
  nmap <leader>r :NERDTreeFind<cr>
  let NERDTreeShowHidden=1
  let NERDTreeIgnore = ['\.DS_Store$', '\.gitkeep$', '\.git$']

Plug 'terryma/vim-expand-region'
  vmap v <Plug>(expand_region_expand)
  vmap <C-v> <Plug>(expand_region_shrink)

Plug 'ton/vim-bufsurf'
  nmap [ :BufSurfBack<cr>
  nmap ] :BufSurfForward<cr>

Plug 'ctrlpvim/ctrlp.vim'
  nmap <leader>t :CtrlP<cr>
  let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""'

Plug 'Valloric/YouCompleteMe', {'do': 'python install.py'}
  let g:ycm_collect_identifiers_from_tags_files = 1
  let g:ycm_min_num_of_chars_for_completion = 3
  let g:ycm_path_to_python_interpreter = '/usr/local/bin/python'

Plug 'alisnic/tube.vim'
  let g:tube_terminal = "iterm"

Plug 'mileszs/ack.vim'
  let g:ackpreview = 1
  let g:ackprg = 'ag --vimgrep'

call plug#end()

call expand_region#custom_text_objects({"t.": 1})

" Delete trailing spaces on save
autocmd BufWritePre * :%s/\s\+$//e

set background=light
colorscheme solarized
hi MatchParen guibg=lightgrey guifg=NONE

set mouse=a
set list listchars=trail:-,tab:>-
set clipboard+=unnamedplus
set hidden
set completeopt-=preview

" UI
set cul
set nu!
set sidescroll=1
set wrap!
set colorcolumn=80
set noshowmode
set noshowcmd
set laststatus=0

" Filesystem
set nobackup
set nowritebackup
set noswapfile

" Indent
set tabstop=2
set expandtab
set shiftwidth=2

" Search
set hlsearch
set ignorecase
set smartcase
map <esc><esc> :nohlsearch<cr>

" Folds
set foldlevelstart=99
set foldmethod=indent " foldmethod=syntax is slow
nmap ff za

" Tag navigation
set tags=.git/tags
set tc=match
nmap <leader>d g]
vmap <leader>d g]
vmap ] <C-]>

" Split navigation
nnoremap <S-UP> <C-w><UP>
nnoremap <S-Down> <C-w><Down>
nnoremap <S-Left> <C-w><Left>
nnoremap <S-Right> <C-w><Right>

cabbrev te tabedit
command W w
nmap ; :

nmap <leader>m <C-w>t<cr>
nmap <leader>ln :setlocal nu!<cr>

nmap q b
nmap § ``
vnoremap <S-UP> <NOP>
vnoremap <S-Down> <NOP>
vnoremap <leader>p "_dP
