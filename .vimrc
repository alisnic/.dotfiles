let mapleader = "\<Space>"
let g:loaded_matchparen = 1
let g:python_host_prog = '/usr/local/bin/python2'
let g:python3_host_prog = '/usr/local/bin/python3'

call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-endwise'     " Auto-insert end statements in code
Plug 'tpope/vim-unimpaired'  " awesome pair mappings
Plug 'tpope/vim-surround'    " Surround stuff in chars
Plug 'tpope/vim-fugitive'    " Git integration
Plug 'tpope/vim-bundler'     " read tags from gems
Plug 'tomtom/tcomment_vim'   " Comment code
Plug 'ap/vim-css-color'      " Preview css color
Plug 'majutsushi/tagbar'     " Tag explorer for a buffer
Plug 'RRethy/vim-illuminate' " Highlight matches for current word under cursor
Plug 'altercation/vim-colors-solarized'
Plug 'michaeljsmith/vim-indent-object'
Plug 'tpope/vim-haml'
Plug 'kchmck/vim-coffee-script'

Plug 'SirVer/ultisnips'
  let g:UltiSnipsSnippetDirectories=[$HOME."/.dotfiles/snippets"]
  let g:UltiSnipsExpandTrigger="<tab>"
  let g:UltiSnipsJumpForwardTrigger="<s-tab>"
  let g:UltiSnipsJumpBackwardTrigger="<c-tab>"

Plug 'vim-ruby/vim-ruby'
  let g:ruby_indent_assignment_style = 'variable'

Plug 'tpope/vim-eunuch'
Plug 'justinmk/vim-dirvish'
  let dirvish_mode = ':sort | sort ,^.*/,'
  nnoremap <leader>s :Dirvish<cr>
  autocmd FileType dirvish nnoremap <silent><buffer> r :silent exec "!open %"<cr>

Plug 'tpope/vim-projectionist'
  nnoremap <leader><leader> :AV<cr>

" Async code linting
Plug 'w0rp/ale'
  let g:ale_linters = {'ruby': ['rubocop']}
  let g:ale_lint_on_text_changed = 'normal'
  let g:ale_lint_on_insert_leave = 1
  let g:ale_pattern_options = {'.*\.gem.*\.rb$': {'ale_enabled': 0}}
  let g:ale_set_highlights = 0

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

Plug 'ternjs/tern_for_vim'
Plug 'ervandew/supertab'
  set completeopt-=preview
  set pumheight=10
  let g:loaded_ruby_provider = 1

Plug 'mileszs/ack.vim'
  let g:ackprg = 'rg --vimgrep --no-heading'
  cabbrev ack Ack

call plug#end()
let g:markdown_fenced_languages = ['ruby', 'coffee', 'yaml']

augroup alisnic
  autocmd!

  " Delete trailing spaces on save
  autocmd BufWritePre * :%s/\s\+$//e

  " Auto-reload file when gaining focus
  autocmd FocusGained * checktime

  " Add Ruby tags to Ruby file buffers
  autocmd FileType ruby,eruby,haml setlocal tags=.git/rubytags,~/.rubies/ruby-2.4.4/tags

  " Auto-complete js in html
  autocmd FileType html setlocal omnifunc=tern#Complete | call tern#Enable()

  " Highlight all characters past 80 columns, but only in buffers with code
  autocmd BufEnter * highlight OverLength ctermbg=7 guibg=Grey90
  autocmd BufEnter * if &ft != '' | match OverLength /\%81v.*/ | endif

  " Use omnifunc if it's available, otherwise use keyword completion
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

set autowriteall
set nobackup
set nowritebackup
set noswapfile

set tabstop=2
set expandtab
set shiftwidth=2
set autoindent

set ignorecase
set smartcase
nnoremap <silent> <esc><esc> :nohlsearch<cr><esc>

set foldenable
set foldlevelstart=99
set foldmethod=indent " foldmethod=syntax is slow

set tags+=.git/tags
set tagcase=match

nnoremap <leader>] :vsp <CR>:exec("tag ".expand("<cword>"))<CR>
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
