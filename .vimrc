let mapleader = "\<Space>"
call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-sensible'   " Vim defaults hopefully everyone agrees on
Plug 'tpope/vim-endwise'    " Auto-insert end statements in code
Plug 'tpope/vim-unimpaired' " awesome pair mappings
Plug 'tpope/vim-surround'   " Surround stuff in chars
Plug 'tpope/vim-fugitive'   " Git integration
Plug 'tomtom/tcomment_vim'  " Comment code
Plug 'ap/vim-css-color'     " Preview css color
Plug 'altercation/vim-colors-solarized'
Plug 'michaeljsmith/vim-indent-object'

" Snippet generation
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
  let g:UltiSnipsExpandTrigger="<tab>"
  let g:UltiSnipsJumpForwardTrigger="<tab>"
  let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

" Async code linting
Plug 'neomake/neomake'
  let g:neomake_ruby_enabled_makers = ['rubocop']

" Preserve intendation when pasting
Plug 'sickill/vim-pasta'
  let g:pasta_disabled_filetypes = ['coffee', 'yaml', 'haml']

" Align code by characters
Plug 'tommcdo/vim-lion'
  let g:lion_squeeze_spaces = 1

" A collection of language plugins
Plug 'kchmck/vim-coffee-script'
Plug 'fatih/vim-go'
Plug 'artur-shaik/vim-javacomplete2'
Plug 'vim-ruby/vim-ruby'
  let g:ruby_indent_assignment_style = 'variable'

" Preserve buffer navigation history
Plug 'ton/vim-bufsurf'
  nnoremap <backspace> :BufSurfBack<cr>
  nnoremap <S-backspace> :BufSurfForward<cr>

" Per-project file mappings
Plug 'tpope/vim-projectionist'
  nnoremap <leader><leader> :AV<cr>

Plug 'scrooloose/nerdtree'
  nnoremap <leader>s :NERDTreeToggle<cr>
  nnoremap <leader>r :NERDTreeFind<cr>
  let NERDTreeIgnore = ['\.DS_Store$']
  let NERDTreeShowHidden = 1

Plug 'ctrlpvim/ctrlp.vim'
Plug 'FelikZ/ctrlp-py-matcher'
  let g:ctrlp_mruf_relative = 1
  let g:ctrlp_mruf_exclude  = '\.git/.*'
  let g:ctrlp_user_command  = 'ag %s -l --nocolor --hidden -g ""'
  let g:ctrlp_match_func    = { 'match': 'pymatcher#PyMatch' }
  let g:ctrlp_max_depth     = 10

Plug 'ervandew/supertab'
  set completeopt-=preview
  let g:SuperTabDefaultCompletionType = 'context'

" Search code
Plug 'mileszs/ack.vim'
  let g:ackpreview = 1
  let g:ackprg     = 'ag --vimgrep'

call plug#end()

augroup alisnic
  autocmd!
  autocmd BufWritePre * :%s/\s\+$//e " Delete trailing spaces on save
  autocmd BufNewFile,BufRead *.hamlc setlocal ft=haml
  autocmd BufWritePost,BufReadPost *.rb,*.coffee Neomake
  autocmd FileType java setlocal omnifunc=javacomplete#Complete
  autocmd FileType *
    \ if &omnifunc != '' |
    \   call SuperTabChain(&omnifunc, "<c-p>") |
    \ endif
augroup END

set background=light
colorscheme solarized
hi MatchParen guibg=#cac3b0
set synmaxcol=200

set wrap!
set splitright
set hidden
set clipboard=unnamed

set autowriteall
set nobackup
set nowritebackup
set noswapfile

set tabstop=2
set expandtab
set shiftwidth=2

set hlsearch
set ignorecase
set smartcase
nnoremap <silent> <esc><esc> :nohlsearch<cr><esc>

set foldlevelstart=99
set foldmethod=indent " foldmethod=syntax is slow

set tags+=.git/tags,.git/rubytags
set tagcase=match

noremap <leader>t :exec("term " . &makeprg) \| wincmd T<cr>
noremap <leader>f :exec("term " . &makeprg . ":" . line('.')) \| wincmd T<cr>
noremap <S-UP> <C-w><UP>
noremap <S-Down> <C-w><Down>
noremap <S-Left> <C-w><Left>
noremap <S-Right> <C-w><Right>

" I do a lot of shift typos, these are the most common ones
command! W w
command! Wq wq
command! Q q
nnoremap Q <Nop>
