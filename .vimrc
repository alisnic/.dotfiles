let mapleader = "\<Space>"
call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-endwise'       " Auto-insert end statements in code
Plug 'tpope/vim-unimpaired'    " awesome pair mappings
Plug 'tpope/vim-surround'      " Surround stuff in chars
Plug 'tpope/vim-fugitive'      " Git integration
Plug 'tpope/vim-bundler'       " read tags from gems
Plug 'tomtom/tcomment_vim'     " Comment code
Plug 'ap/vim-css-color'        " Preview css color
Plug 'altercation/vim-colors-solarized'
Plug 'michaeljsmith/vim-indent-object'
Plug 'majutsushi/tagbar'
Plug 'kchmck/vim-coffee-script'

Plug 'scrooloose/nerdtree'
  nnoremap <leader>s :NERDTreeToggle<cr>
  nnoremap <leader>r :NERDTreeFind<cr>

Plug 'tpope/vim-projectionist'
  nnoremap <leader><leader> :AV<cr>

" Async code linting
Plug 'neomake/neomake'
  let g:neomake_ruby_enabled_makers = ['rubocop']

" Preserve intendation when pasting
Plug 'sickill/vim-pasta'
  let g:pasta_disabled_filetypes = ['coffee', 'yaml', 'haml']

" Align code by characters
Plug 'tommcdo/vim-lion'
  let g:lion_squeeze_spaces = 1

Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
  nnoremap <leader>f :Files<cr>
  nnoremap <leader>m :BTags<cr>
  nnoremap <leader>c :Tags<cr>
  nnoremap <leader>b :Buffers<cr>

Plug 'ervandew/supertab'
  set completeopt-=preview
  set pumheight=5
  let g:loaded_ruby_provider = 1
  let g:SuperTabDefaultCompletionType = 'context'
  let g:SuperTabContextDefaultCompletionType = '<c-n>'

Plug 'mileszs/ack.vim'
  let g:ackprg = 'ag --vimgrep'

call plug#end()
call neomake#configure#automake('rw')
let g:markdown_fenced_languages = ['ruby', 'coffee', 'yaml']

augroup alisnic
  autocmd!
  autocmd BufWritePre * :%s/\s\+$//e " Delete trailing spaces on save
  autocmd BufNewFile,BufRead *.hamlc setlocal ft=haml
  autocmd FocusGained * checktime
  autocmd VimLeavePre * set titlestring=
  autocmd BufEnter * highlight OverLength ctermbg=7 guibg=Grey90
  autocmd BufEnter * match OverLength /\%80v.*/
  autocmd FileType *
    \ if &omnifunc != '' |
    \   call SuperTabChain(&omnifunc, "<c-n>") |
    \ endif
augroup END

set background=light
colorscheme solarized
set synmaxcol=200

set title
set titlestring=%f
set laststatus=0
set mouse=a
set splitright
set hidden
set clipboard=unnamed
set cursorline

set autoread
set autowriteall
set nobackup
set nowritebackup
set noswapfile

set tabstop=2
set expandtab
set shiftwidth=2

set ignorecase
set smartcase
nnoremap <silent> <esc><esc> :nohlsearch<cr><esc>

set foldlevelstart=99
set foldmethod=indent " foldmethod=syntax is slow

set tags+=.git/tags,.git/rubytags
set tagcase=match

imap <M-Backspace> <C-w>

nnoremap <leader>q @
nnoremap <leader>t :exec("tabedit \| term " . &makeprg) \| startinsert<cr>
nnoremap <leader>l :exec("tabedit \| term " . &makeprg . ":" . line('.')) \| startinsert<cr>
nnoremap <S-UP> <C-w><UP>
nnoremap <S-Down> <C-w><Down>
nnoremap <S-Left> <C-w><Left>
nnoremap <S-Right> <C-w><Right>
nnoremap <UP> gk
nnoremap <Down> gj

" I do a lot of shift typos, these are the most common ones
command! W w
command! Wq wq
command! Q q
nnoremap Q <nop>
nnoremap q: <nop>
vnoremap <S-UP> <nop>
vnoremap <S-Down> <nop>
