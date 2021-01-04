let mapleader = "\<Space>"
let g:loaded_matchparen = 1
let g:loaded_ruby_provider = 1
let g:loaded_node_provider = 1

function! RunInTerminal(cmd)
  if has("nvim")
    exec("tabedit \| term " . a:cmd)
    startinsert
  else
    exec("tab terminal " . a:cmd)
  endif
endfunction

call plug#begin('~/.vim/plugged')

if !has("nvim")
  Plug 'tpope/vim-sensible'
endif

" Basic config
Plug 'tpope/vim-endwise'      " Auto-insert end statements in code
Plug 'tpope/vim-unimpaired'   " awesome pair mappings
Plug 'tpope/vim-bundler'      " read tags from gems
Plug 'google/vim-searchindex' " show number of search matches
Plug 'RRethy/vim-illuminate'  " Highlight matches for current word under cursor
Plug 'tomtom/tcomment_vim'    " Comment code
Plug 'michaeljsmith/vim-indent-object'
Plug 'morhetz/gruvbox'
Plug 'altercation/vim-colors-solarized'
Plug 'majutsushi/tagbar'
Plug 'tpope/vim-haml'
Plug 'kchmck/vim-coffee-script'
Plug 'alvan/vim-closetag'
  let g:closetag_filetypes = 'html,xhtml,phtml,javascript'

" Workflow: TDD
Plug 'tpope/vim-projectionist'
  nnoremap <leader>va :AT<cr>
  nnoremap <leader>a :A<cr>
  nnoremap <leader>t :call RunInTerminal(&makeprg)<cr>
  nnoremap <leader>l :call RunInTerminal(&makeprg . ":" . line('.'))<cr>
  nnoremap <leader>r :call RunInTerminal(&makeprg . " --only-failures")<cr>

" Workflow: Git/Gitlab
Plug 'tpope/vim-fugitive'
Plug 'shumphrey/fugitive-gitlab.vim'

" Workflow: JavaScript
Plug 'prettier/vim-prettier'
Plug 'ternjs/tern_for_vim', { 'do' : 'npm install' }
  autocmd FileType javascript setlocal omnifunc=tern#Complete | call SuperTabChain(&omnifunc, "<c-n>")

" Workflow: React
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
Plug 'MaxMEllon/vim-jsx-pretty'

" Workflow: Ruby/RoR
Plug 'vim-ruby/vim-ruby'
  let g:ruby_indent_assignment_style = 'variable'
  autocmd FileType ruby,haml setlocal tags+=.git/rubytags | setlocal tags-=.git/tags

" Workflow: File management
Plug 'tpope/vim-eunuch'
Plug 'justinmk/vim-dirvish'
  let dirvish_mode = ':sort | sort ,^.*/,'
  autocmd FileType dirvish nnoremap <silent><buffer> r :silent exec "!open %"<cr>

" Feature: Async code linting
Plug 'w0rp/ale'
  let g:ale_linters = {'ruby': ['rubocop']}
  let g:ale_pattern_options = {'.*\.gem.*\.rb$|.*\.rubies.*\.rb$': {'ale_enabled': 0}}
  let g:ale_set_highlights = 0
  let g:ale_ruby_rubocop_executable = "bundle"

" Feature: preserve intendation when pasting
Plug 'sickill/vim-pasta'
  let g:pasta_disabled_filetypes = ['coffee', 'yaml', 'haml']

" Feature: align code by characters
Plug 'tommcdo/vim-lion'
  let g:lion_squeeze_spaces = 1

Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
  function! s:switch_project(name)
    execute 'cd ~/Work/' . a:name . ' | bufdo bd | Dirvish'
  endfunction

  nnoremap <leader>f :Files<cr>
  nnoremap <leader>b :Buffers<cr>
  nnoremap <leader>m :BTags<cr>
  nnoremap <leader>c :Tags<cr>
  nnoremap <silent> <leader>d :call fzf#run(fzf#wrap({'source': 'find . -type d \| grep -v tmp \| grep -v .git'}))<cr>
  nnoremap <silent> <leader>p :call fzf#run(fzf#wrap(
    \ {'source': 'find ~/Work/* -type d -maxdepth 0 \| xargs basename',
    \  'sink': function('<sid>switch_project')}))<cr>

  let g:fzf_preview_window = ''

function! GitCheckoutBranch(branch)
    let l:name = split(split(trim(a:branch), "", 1)[0], "/", 1)[-1]
    silent execute "Git checkout ". l:name
endfunction

nnoremap <silent> <leader>gb :call fzf#run(fzf#wrap({'source': 'git branch -avv --color --sort=-committerdate \| grep -v remotes', 'sink': function('GitCheckoutBranch'), 'options': '--ansi --nth=1'}))<cr>

" Feature: autocomplete
Plug 'ervandew/supertab'
  set completeopt-=preview
  set pumheight=10

" Feature: search in all files
Plug 'mileszs/ack.vim'
  let g:ackprg = 'rg --vimgrep'
  cabbrev ack Ack

call plug#end()
let g:markdown_fenced_languages = ['ruby', 'coffee', 'yaml']

augroup alisnic
  autocmd!
  autocmd BufWritePre * :%s/\s\+$//e
  autocmd FocusGained * checktime
  autocmd FileType markdown setlocal spell
  autocmd FileType markdown syn match UrlNoSpell '\w\+:\/\/[^[:space:]]\+' contains=@NoSpell
  autocmd FileType text setlocal modeline

  " autocmd FileType *
  "   \ if &omnifunc != '' |
  "   \   call SuperTabChain(&omnifunc, "<c-p>")
  "   \ endif
augroup END

" set termguicolors
colorscheme solarized
set background=light
set synmaxcol=200

set title
set titlestring=%f
set laststatus=0
set mouse=a
set splitright
set hidden
set clipboard=unnamed
set winwidth=78
set virtualedit=block

set autowriteall
set nobackup
set nowritebackup
set noswapfile
set exrc
set secure

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

set tags+=.git/tags " ,~/.rubies/ruby-2.4.6/tags,~/src/ruby-2.4.6/tags
set tagcase=match
nnoremap <leader>] :vsp <CR>:exec("tag ".expand("<cword>"))<CR>

function! s:FilterQuickfixList(bang, pattern)
  let cmp = a:bang ? '!~#' : '=~#'
  call setqflist(filter(getqflist(), "bufname(v:val['bufnr']) " . cmp . " a:pattern"))
endfunction
command! -bang -nargs=1 -complete=file Qfilter call s:FilterQuickfixList(<bang>0, <q-args>)

" nnoremap <leader>w :tabclose<cr>
nnoremap <S-UP> <C-w><UP>
nnoremap <S-Down> <C-w><Down>
nnoremap <S-Left> <C-w><Left>
nnoremap <S-Right> <C-w><Right>
nnoremap <leader><leader> :Files<cr>
nnoremap <UP> gk
nnoremap <Down> gj

command! Scratch :exe "e " . "~/.notes/scratch/" . strftime('%Y-%m-%d') . ".txt"
command! Focus :exe "normal! zMzv"

nnoremap <leader>. :e ~/.vimrc<cr>
command! Reload :source ~/.vimrc
cabbrev reload Reload
cabbrev te tabedit

" I do a lot of shift typos, these are the most common ones
command! W w
command! Wq wq
command! Q q
nnoremap Q <nop>
nnoremap q: <nop>
vnoremap <S-UP> <nop>
vnoremap <S-Down> <nop>

if filereadable(expand("~/.vimrc.private"))
  exe 'source ~/.vimrc.private'
endif
