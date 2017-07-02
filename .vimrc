let mapleader = "\<Space>"
call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-sensible'            " Vim defaults hopefully everyone agrees on
Plug 'tpope/vim-endwise'             " Auto-insert end statements in code
Plug 'tpope/vim-unimpaired'          " awesome pair mappings
Plug 'jszakmeister/vim-togglecursor' " Toggle cursor shape in insert mode in term
Plug 'tomtom/tcomment_vim'           " Comment code
Plug 'sickill/vim-pasta'             " Preserve intendation when pasting
Plug 'Raimondi/delimitMate'          " Auto-close quotes and parens
Plug 'Konfekt/FastFold'              " Make folds fast again
Plug 'altercation/vim-colors-solarized'
Plug 'michaeljsmith/vim-indent-object'

" Git integration
Plug 'tpope/vim-fugitive'
  nmap <leader>g :Gstatus<cr>gg<C-n>

" Align code by characters
Plug 'tommcdo/vim-lion'
  let g:lion_squeeze_spaces = 1

" A collection of language plugins
Plug 'sheerun/vim-polyglot'
  let g:ruby_indent_access_modifier_style = 'outdent'
  let g:ruby_indent_assignment_style = 'variable'

" Preserve buffer navigation history
Plug 'ton/vim-bufsurf'
  nmap <backspace> :BufSurfBack<cr>
  nmap <S-backspace> :BufSurfForward<cr>

" Per-project file mappings
Plug 'tpope/vim-projectionist'
  nnoremap <leader><leader> :AV<cr>

" Async code linting
Plug 'neomake/neomake'
  autocmd! BufWritePost * Neomake

Plug 'scrooloose/nerdtree'
  nmap <leader>s :NERDTreeToggle<cr>
  nmap <leader>r :NERDTreeFind<cr>
  let NERDTreeShowHidden = 1

" Expand a visual selection automatically
Plug 'terryma/vim-expand-region'
  vmap v <Plug>(expand_region_expand)

Plug 'ctrlpvim/ctrlp.vim'
  let g:ctrlp_mruf_relative = 1
  let g:ctrlp_user_command  = 'ag %s -l --nocolor --hidden -g ""'

Plug 'Valloric/YouCompleteMe', {'do': 'python install.py'}
  let g:ycm_collect_identifiers_from_tags_files = 1
  let g:ycm_path_to_python_interpreter = '/usr/local/bin/python'

" Execute commands in iTerm (used together with MacVim)
Plug 'alisnic/tube.vim'
  let g:tube_terminal = "iterm"

" Search code
Plug 'mileszs/ack.vim'
  let g:ackpreview = 1
  let g:ackprg     = 'ag --vimgrep'
  set keywordprg=:Ack " K searches current keyword

call plug#end()
call expand_region#custom_text_objects({"t.": 1})

autocmd BufWritePre * :%s/\s\+$//e " Delete trailing spaces on save

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
set hidden
set clipboard=unnamed

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

" Tag navigation
set tags=.git/tags
set tc=match
map <leader>d g<C-]>

" Split navigation
map <S-UP> <C-w><UP>
map <S-Down> <C-w><Down>
map <S-Left> <C-w><Left>
map <S-Right> <C-w><Right>

" I do a lot of shift typos, these are the most common ones
command W w
command Q q
