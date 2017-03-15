let mapleader = "\<Space>"

call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-sensible'
Plug 'altercation/vim-colors-solarized'
Plug 'godlygeek/tabular'
Plug 'tpope/vim-endwise'
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

Plug 'vim-ruby/vim-ruby'
  let g:no_ruby_maps = 1
  let g:ruby_indent_access_modifier_style = 'outdent'
  let g:ruby_indent_assignment_style = 'variable'
  autocmd FileType ruby setlocal indentkeys-=.

Plug 'tpope/vim-projectionist'
  if (winwidth(0) > 160)
    nnoremap <leader><leader> :AV<cr>
    set nu!
  else
    nnoremap <leader><leader> :AT<cr>
  endif

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
  let g:expand_region_text_objects = {
    \ 't.'  :1,
    \ 'iw'  :0,
    \ 'iW'  :0,
    \ 'i"'  :0,
    \ 'i''' :0,
    \ 'i]'  :1,
    \ 'ib'  :1,
    \ 'iB'  :1,
    \ 'il'  :0,
    \ 'ip'  :0,
    \ 'ie'  :0,
    \ }

Plug 'ton/vim-bufsurf'
  nnoremap [ :BufSurfBack<cr>
  nnoremap ] :BufSurfForward<cr>

Plug 'FelikZ/ctrlp-py-matcher'
Plug 'ctrlpvim/ctrlp.vim'
  nmap <leader>t :CtrlP<cr>
  let g:ctrlp_show_hidden = 1
  let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
  let g:ctrlp_prompt_mappings = {
        \ 'AcceptSelection("e")': ['<c-t>'],
        \ 'AcceptSelection("t")': ['<cr>', '<2-LeftMouse>'],
        \ }

  if executable('ag')
    let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""'
  endif

Plug 'Valloric/YouCompleteMe', {'do': 'python install.py'}
  let g:ycm_collect_identifiers_from_tags_files = 1
  let g:ycm_min_num_of_chars_for_completion = 3
  let g:ycm_path_to_python_interpreter = '/usr/local/bin/python'

Plug 'alisnic/tube.vim'
  let g:tube_terminal = "iterm"

Plug 'mileszs/ack.vim'
  let g:ackpreview = 1
  if executable('ag')
    let g:ackprg = 'ag --vimgrep'
  endif

call plug#end()

" Restore cursor position when reopening buffer
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
  \| exe "normal! g'\"" | endif

" Delete trailing spaces on save
autocmd BufWritePre * :%s/\s\+$//e

set background=light
colorscheme solarized
hi MatchParen guibg=lightgrey guifg=NONE

set mouse=a
set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
set list listchars=trail:-,tab:>-
set clipboard+=unnamedplus
set cul
set hidden
set completeopt-=preview

" Wrapping/scrolling
set sidescroll=1
set wrap!
set colorcolumn=80

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
set smartcase
map <esc><esc> :nohlsearch<cr>

" Status line
set noshowmode
set noshowcmd
set laststatus=0

" Folds
set foldlevelstart=99
set foldmethod=indent
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
cabbrev help tab help
command W w

" Dear Vim lords, please have mercy on my poor mortal soul
nmap q b
nmap ; :
nmap § ``
vnoremap <S-UP> <NOP>
vnoremap <S-Down> <NOP>

nmap <leader>ln :setlocal nu!<cr>
" Paste without overriding register
vnoremap <leader>p "_dP
