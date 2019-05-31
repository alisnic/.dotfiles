let mapleader = "\<Space>"
let g:loaded_matchparen = 1
let g:loaded_python_provider = 1
let g:loaded_python3_provider = 1
let g:loaded_ruby_provider = 1
let g:loaded_node_provider = 1

call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-endwise'     " Auto-insert end statements in code
Plug 'tpope/vim-unimpaired'  " awesome pair mappings
Plug 'tpope/vim-bundler'     " read tags from gems
Plug 'tomtom/tcomment_vim'   " Comment code
Plug 'majutsushi/tagbar'     " Tag explorer for a buffer
Plug 'RRethy/vim-illuminate' " Highlight matches for current word under cursor
Plug 'altercation/vim-colors-solarized'
Plug 'michaeljsmith/vim-indent-object'
Plug 'tpope/vim-haml'
Plug 'kchmck/vim-coffee-script'
Plug 'tpope/vim-fugitive'

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
  let g:ale_pattern_options = {'.*\.gem.*\.rb$|.*\.rubies.*\.rb$': {'ale_enabled': 0}}
  let g:ale_set_highlights = 0

" Preserve intendation when pasting
Plug 'sickill/vim-pasta'
  let g:pasta_disabled_filetypes = ['coffee', 'yaml', 'haml']

" Align code by characters
Plug 'tommcdo/vim-lion'
  let g:lion_squeeze_spaces = 1

Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
  function! s:switch_project(name)
    execute 'cd ~/Work/' . a:name . ' | Dirvish | wa | %bd | e#'
  endfunction

  nnoremap <leader>f :Files<cr>
  nnoremap <leader>m :BTags<cr>
  nnoremap <leader>c :Tags<cr>
  nnoremap <leader>b :Buffers<cr>
  nnoremap <leader>d :call fzf#run(fzf#wrap({'source': 'find . -type d \| grep -v tmp \| grep -v .git'}))<cr>
  nnoremap <leader>p :call fzf#run(fzf#wrap(
    \ {'source': 'find ~/Work/* -type d -maxdepth 0 \| xargs basename',
    \  'sink': function('<sid>switch_project')}))<cr>

Plug 'ervandew/supertab'
  set completeopt-=preview
  set pumheight=10

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

  autocmd FileType markdown setlocal spell

  " Use omnifunc if it's available, otherwise use keyword completion
  autocmd FileType *
    \ if &omnifunc != '' |
    \   call SuperTabChain(&omnifunc, "<c-n>") |
    \ endif
augroup END

function! s:FilterQuickfixList(bang, pattern)
  let cmp = a:bang ? '!~#' : '=~#'
  call setqflist(filter(getqflist(), "bufname(v:val['bufnr']) " . cmp . " a:pattern"))
endfunction
command! -bang -nargs=1 -complete=file Qfilter call s:FilterQuickfixList(<bang>0, <q-args>)

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
set guicursor=

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

set tags+=.git/tags,.git/rubytags,~/.rubies/ruby-2.4.5/tags,~/src/ruby-2.4.5/tags
set tagcase=match
nnoremap <leader>] :vsp <CR>:exec("tag ".expand("<cword>"))<CR>

nnoremap <leader>t :exec("tabedit \| term " . &makeprg) \| startinsert<cr>
nnoremap <leader>l :exec("tabedit \| term " . &makeprg . ":" . line('.')) \| startinsert<cr>
nnoremap <S-UP> <C-w><UP>
nnoremap <S-Down> <C-w><Down>
nnoremap <S-Left> <C-w><Left>
nnoremap <S-Right> <C-w><Right>
nnoremap <UP> gk
nnoremap <Down> gj

command! Scratch :exe "e " . "~/.scratch/" . strftime('%Y-%m-%d') . ".txt"
command! Focus :exe "normal! zMzv"

" I do a lot of shift typos, these are the most common ones
command! W w
command! Wq wq
command! Q q
nnoremap Q <nop>
nnoremap q: <nop>
vnoremap <S-UP> <nop>
vnoremap <S-Down> <nop>
