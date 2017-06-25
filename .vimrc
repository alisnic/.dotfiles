let mapleader = "\<Space>"
call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-sensible'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-unimpaired'
Plug 'jszakmeister/vim-togglecursor'
Plug 'tomtom/tcomment_vim'
Plug 'sickill/vim-pasta'  " Preserve intendation when pasting
Plug 'altercation/vim-colors-solarized'
Plug 'michaeljsmith/vim-indent-object'
Plug 'Raimondi/delimitMate'

Plug 'vim-scripts/sessionman.vim'
  nmap <leader>p :SessionList<cr>

Plug 'tommcdo/vim-lion'
  let g:lion_squeeze_spaces = 1

Plug 'sheerun/vim-polyglot'
  let g:ruby_indent_access_modifier_style = 'outdent'
  let g:ruby_indent_assignment_style = 'variable'

Plug 'alisnic/vim-bufsurf'
  nmap <backspace> :BufSurfBack<cr>
  nmap <S-backspace> :BufSurfForward<cr>

Plug 'tpope/vim-projectionist'
  nnoremap <leader><leader> :AV<cr>

Plug 'neomake/neomake'
  autocmd! BufWritePost * Neomake

Plug 'scrooloose/nerdtree'
  nmap <leader>s :NERDTreeToggle<cr>
  nmap <leader>r :NERDTreeFind<cr>
  let NERDTreeShowHidden=1
  let NERDTreeIgnore = ['\.DS_Store$', '\.gitkeep$', '\.git$']

Plug 'terryma/vim-expand-region'
  vmap v <Plug>(expand_region_expand)

Plug 'ctrlpvim/ctrlp.vim'
  let g:ctrlp_mruf_relative = 1
  let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""'

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

set hidden
set clipboard=unnamed

" UI
set background=light
colorscheme solarized
set mouse=a
set cul
set nu!
set sidescroll=1
set wrap!
set colorcolumn=80
set splitright
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
set nofoldenable
set foldmethod=indent " foldmethod=syntax is slow

" Tag navigation
set tags=.git/tags
set tc=match

" Split navigation
map <S-UP> <C-w><UP>
map <S-Down> <C-w><Down>
map <S-Left> <C-w><Left>
map <S-Right> <C-w><Right>

command W w
command Q q
