let mapleader = "\<Space>"
call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-sensible'   " Vim defaults hopefully everyone agrees on
Plug 'tpope/vim-endwise'    " Auto-insert end statements in code
Plug 'tpope/vim-unimpaired' " awesome pair mappings
Plug 'tomtom/tcomment_vim'  " Comment code
Plug 'sickill/vim-pasta'    " Preserve intendation when pasting
Plug 'Raimondi/delimitMate' " Auto-close quotes and parens
Plug 'Konfekt/FastFold'     " Make folds fast again
Plug 'altercation/vim-colors-solarized'
Plug 'michaeljsmith/vim-indent-object'

" Git integration
Plug 'tpope/vim-fugitive'
  nmap <leader>gs :Gstatus \| wincmd T<cr>

" Align code by characters
Plug 'tommcdo/vim-lion'
  let g:lion_squeeze_spaces = 1

" A collection of language plugins
Plug 'sheerun/vim-polyglot'
  let g:ruby_indent_assignment_style = 'variable'

" Preserve buffer navigation history
Plug 'ton/vim-bufsurf'
  nnoremap <backspace> :BufSurfBack<cr>
  nnoremap <S-backspace> :BufSurfForward<cr>

" Per-project file mappings
Plug 'tpope/vim-projectionist'
  nnoremap <leader><leader> :AV<cr>

" Async code linting
Plug 'neomake/neomake'
  autocmd! BufWritePost,BufReadPost * Neomake

Plug 'scrooloose/nerdtree'
  nnoremap <leader>s :NERDTreeToggle<cr>
  nnoremap <leader>r :NERDTreeFind<cr>
  let NERDTreeShowHidden = 1

" Expand a visual selection automatically
Plug 'terryma/vim-expand-region'
  vmap v <Plug>(expand_region_expand)

Plug 'ctrlpvim/ctrlp.vim'
Plug 'FelikZ/ctrlp-py-matcher'
  let g:ctrlp_mruf_relative = 1
  let g:ctrlp_mruf_exclude  = '\.git/.*'
  let g:ctrlp_user_command  = 'ag %s -l --nocolor --hidden -g ""'
  let g:ctrlp_match_func    = { 'match': 'pymatcher#PyMatch' }

Plug 'ervandew/supertab'
  let g:SuperTabDefaultCompletionType = "<c-n>"
  set completeopt+=menuone

" Search code
Plug 'mileszs/ack.vim'
  let g:ackpreview = 1
  let g:ackprg     = 'ag --vimgrep'

call plug#end()
call expand_region#custom_text_objects({"t.": 1})

autocmd BufWritePre * :%s/\s\+$//e " Delete trailing spaces on save
autocmd BufNewFile,BufRead *.hamlc setlocal ft=haml
autocmd BufEnter * if &l:buftype ==# 'terminal' | hi Normal guibg=#ffffff | setlocal nocursorline | setlocal nu! | setlocal colorcolumn=0 | endif
autocmd BufLeave * if &l:buftype ==# 'terminal' | hi Normal guibg=#fdf6e3 | endif

set background=light
colorscheme solarized
set mouse=a
set cursorline
set number!
set sidescroll=1
set wrap!
set colorcolumn=80
set splitright
set laststatus=0
set showmode
set hidden
set clipboard=unnamed

" Filesystem
set autowriteall
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
noremap <esc><esc> :nohlsearch<cr>

" Folds
set foldlevelstart=99
set foldmethod=indent " foldmethod=syntax is slow

" Tag navigation
set tags=.git/tags
set tc=match
map <leader>d g<C-]>
nmap <leader>c vt.g<C-]>

" Split navigation
noremap <S-UP> <C-w><UP>
noremap <S-Down> <C-w><Down>
noremap <S-Left> <C-w><Left>
noremap <S-Right> <C-w><Right>

nmap <leader>pr :silent !cpr<cr>

" I do a lot of shift typos, these are the most common ones
command W w
command Q q
