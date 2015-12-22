" filetype plugin on
call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-sensible'
Plug 'tomtom/tcomment_vim'
Plug 'terryma/vim-expand-region'
Plug 'cyphactor/vim-open-alternate'
Plug 'godlygeek/tabular'
" Enable tags from ruby gems
Plug 'tpope/vim-bundler'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-endwise'
Plug 'xiaogaozi/easy-gitlab.vim'
  let g:easy_gitlab_url = 'https://git.saltedge.com'

" Lang support
Plug 'vim-ruby/vim-ruby'
Plug 'elixir-lang/vim-elixir'
Plug 'tpope/vim-haml'
Plug 'kchmck/vim-coffee-script'
Plug 'pangloss/vim-javascript'

if has('nvim')
  let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
else
  Plug 'jszakmeister/vim-togglecursor'
endif

Plug 'gcmt/tube.vim'
  let g:tube_terminal = "iterm"

Plug 'FelikZ/ctrlp-py-matcher'
Plug 'kien/ctrlp.vim'
  let g:ctrlp_show_hidden = 1
  let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
  let g:ctrlp_prompt_mappings = {
        \ 'AcceptSelection("e")': ['<c-t>'],
        \ 'AcceptSelection("t")': ['<cr>', '<2-LeftMouse>'],
        \ }

  let g:ctrlp_clear_cache_on_exit=1
  if executable('ag')
    let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
  endif

Plug 'alisnic/YouCompleteMe'
  let g:ycm_collect_identifiers_from_tags_files = 1
  let g:ycm_min_num_of_chars_for_completion = 3
  let g:ycm_collect_identifiers_from_comments_and_strings = 1

Plug 'mileszs/ack.vim'
  let g:ackpreview = 1
  if executable('ag')
    let g:ackprg = 'ag --vimgrep'
  endif

Plug 'altercation/vim-colors-solarized'
call plug#end()

" Delete trailing spaces on save
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
  \| exe "normal! g'\"" | endif
autocmd BufWritePre * :%s/\s\+$//e
autocmd FileType nerdtree nmap <buffer> <left> x
autocmd FileType nerdtree nmap <buffer> <right> <cr>

" se t_Co=256
syntax enable
filetype plugin indent on
set background=light
colorscheme solarized

set mouse=a
set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
set guitablabel=%t
set list listchars=trail:-,tab:>-
set tags=.git/tags
set backspace=indent,eol,start
set enc=utf-8
set nu
set clipboard+=unnamedplus
set cul

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
set incsearch
set ignorecase
set smartcase

" Per-project vimrcs
set exrc   " enable per-directory .vimrc files
set secure " disable unsafe commands in local .vimrc files
set colorcolumn=80

" Status line
set noshowmode
set noruler
set noshowcmd
set laststatus=0

" Undo
set undofile
set undodir=$HOME/.vim/undo

" PERFORMANCE
let loaded_matchparen=1 " Don't load matchit.vim (paren/bracket matching)
set ttyfast
set nocursorcolumn      " Don't paint cursor column
set lazyredraw          " Wait to redraw
set scrolljump=8        " Scroll 8 lines at a time at bottom/top
let html_no_rendering=1 " Don't render italic, bold, links in HTML
set nofoldenable

let mapleader = "\<Space>"

cabbrev te tabedit
cabbrev qq tabclose
cabbrev help tab help

map <esc><esc> :nohlsearch<cr>
map <C-t> :NERDTreeToggle<cr>
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)
" I don't use macros
nmap q b
nmap ; :
nnoremap <S-UP> <NOP>
nnoremap <S-Down> <NOP>
vnoremap <S-UP> <NOP>
vnoremap <S-Down> <NOP>
nnoremap <BS> :e#<cr>
nnoremap <leader><leader> :OpenAlternate<cr>

" map paste, yank and delete to named register so the content
" will not be overwritten
nnoremap d "xd
vnoremap d "xd
nnoremap D "xD
vnoremap D "xD
nnoremap y "xy
vnoremap y "xy
nnoremap p "xp
vnoremap p "xp
nnoremap P "xP
vnoremap P "xP

noremap <leader>1 1gt
noremap <leader>2 2gt
noremap <leader>3 3gt
noremap <leader>4 4gt
noremap <leader>5 5gt
noremap <leader>6 6gt
noremap <leader>7 7gt
noremap <leader>8 8gt
noremap <leader>9 9gt

nmap <Tab> gt
nmap <S-Tab> gT
nmap <leader>t :CtrlP<cr>
nmap <leader>a ggVG<cr>
nmap <leader>d <C-w><C-]><C-w>T
vmap <leader>d <C-w><C-]><C-w>T
nmap <leader>D g]
vmap <leader>D g]
nmap <leader>/ :TComment<cr>
vmap <leader>/ gc
nmap <leader>r :NERDTreeFind<cr>

function! SearchInFiles()
  let query = input('Search in files: ')
  if len(query) == 0
    return
  endif
  exec ":tabedit | Ack " . query
endfunction
nmap <leader>s :call SearchInFiles()<cr>
