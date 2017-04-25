let mapleader = "\<Space>"

call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-sensible'
Plug 'altercation/vim-colors-solarized'
Plug 'godlygeek/tabular'
Plug 'jszakmeister/vim-togglecursor'
Plug 'bogado/file-line'
Plug 'Raimondi/delimitMate'
Plug 'tpope/vim-fugitive'
Plug 'tomtom/tcomment_vim'
Plug 'artnez/vim-wipeout'

" Language support
Plug 'moll/vim-node'
Plug 'tpope/vim-haml'
Plug 'kchmck/vim-coffee-script'
Plug 'pangloss/vim-javascript'

Plug 'tpope/vim-endwise'
Plug 'vim-ruby/vim-ruby'
  let g:ruby_indent_access_modifier_style = 'outdent'
  let g:ruby_indent_assignment_style = 'variable'
  autocmd FileType ruby setlocal indentkeys-=.

Plug 'ton/vim-bufsurf'
  nmap <backspace> :BufSurfBack<cr>
  nmap <S-backspace> :BufSurfForward<cr>

Plug 'tpope/vim-projectionist'
  nnoremap <leader><leader> :AV<cr>

Plug 'neomake/neomake'
  let g:neomake_verbose = 0
  autocmd BufRead,BufWrite *.coffee,*.rb,*.js Neomake

Plug 'scrooloose/nerdtree'
  nmap <leader>s :NERDTreeToggle<cr>
  nmap <leader>r :NERDTreeFind<cr>
  let NERDTreeShowHidden=1
  let NERDTreeIgnore = ['\.DS_Store$', '\.gitkeep$', '\.git$']

Plug 'terryma/vim-expand-region'
  vmap v <Plug>(expand_region_expand)

Plug 'ctrlpvim/ctrlp.vim'
  let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""'
  nmap <Tab> :CtrlPBuffer<cr>

Plug 'Valloric/YouCompleteMe', {'do': 'python install.py'}
  let g:ycm_collect_identifiers_from_tags_files = 1
  let g:ycm_path_to_python_interpreter = '/usr/local/bin/python'

Plug 'alisnic/tube.vim'
  let g:tube_terminal = "iterm"

Plug 'mileszs/ack.vim'
  let g:ackpreview = 1
  let g:ackprg = 'ag --vimgrep'

call plug#end()
call expand_region#custom_text_objects({"t.": 1})

autocmd BufWritePre * :%s/\s\+$//e " Delete trailing spaces on save

set background=light
colorscheme solarized

set mouse=a
set hidden
set completeopt-=preview
set clipboard=unnamed

" UI
set list listchars=trail:-,tab:>-
set cul
set nu!
set sidescroll=1
set wrap!
set colorcolumn=80
set laststatus=0
set splitright

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
map <leader>d g]

" Split navigation
map <S-UP> <C-w><UP>
map <S-Down> <C-w><Down>
map <S-Left> <C-w><Left>
map <S-Right> <C-w><Right>
cabbrev te tabedit

command W w
nmap <leader>ln :setlocal nu!<cr>
nmap q b
vnoremap <leader>p "_dP
