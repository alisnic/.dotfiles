
call plug#begin('~/.nvim/plugged')

Plug 'gmarik/vundle'
Plug 'tpope/vim-sensible'
Plug 'kien/ctrlp.vim'
Plug 'scrooloose/nerdtree'
Plug 'kchmck/vim-coffee-script'
Plug 'tpope/vim-endwise'
Plug 'Valloric/YouCompleteMe'
Plug 'elixir-lang/vim-elixir'
Plug 'tpope/vim-fugitive'
Plug 'quanganhdo/grb256'
Plug 'tomasr/molokai'

Plug 'bling/vim-airline'       " UI statusbar niceties
  set laststatus=2               " enable airline even if no splits
  let g:airline_theme='luna'
  let g:airline_left_sep = ''
  let g:airline_right_sep = ''
  let g:airline#extensions#tabline#enabled = 0
  let g:airline_mode_map = {
        \ 'n' : 'N',
        \ 'i' : 'I',
        \ 'R' : 'REPLACE',
        \ 'v' : 'VISUAL',
        \ 'V' : 'V-LINE',
        \ 'c' : 'CMD   ',
        \ }

call plug#end()

au BufRead,BufNewFile *.hamlc set ft=haml
" Open files where we left off
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif
endif
autocmd BufWritePre * :%s/\s\+$//e

se t_Co=256
syntax enable
colorscheme molokai

set enc=utf-8
set nobackup
set nowritebackup
set noswapfile
set tabstop=2
set shiftwidth=2
set nu
set clipboard+=unnamedplus
set t_ut= " improve screen clearing by using the background color
set cul
set cuc
" Searching
set hlsearch
set incsearch
set ignorecase
set smartcase
" Enable per-project vimrcs
set exrc   " enable per-directory .vimrc files
set secure " disable unsafe commands in local .vimrc files

let $TERM='screen-256color'
let &t_AB="\e[48;5;%dm"
let &t_AF="\e[38;5;%dm"
let mapleader = "\<Space>"

cabbrev st Gstatus
cabbrev cm Gcommit
cabbrev ph term git push
cabbrev df Gdiff

map <c-c> <esc>
map <C-t> :NERDTreeToggle<cr>
autocmd BufRead *_spec.rb nmap <leader>b :term bin/spring rspec %<cr>

function! OpenTestAlternate()
	let new_file = AlternateForCurrentFile()
	exec ':tab drop ' . new_file
endfunction
  
function! AlternateForCurrentFile()
	let current_file = expand("%")
	let new_file = current_file
	let in_spec = match(current_file, '^spec/') != -1
	let going_to_spec = !in_spec
	let in_app = match(current_file, '\<controllers\>') != -1 || match(current_file, '\<models\>') != -1 || match(current_file, '\<views\>') != -1 || match(current_file, '\<helpers\>') != -1
	if going_to_spec
		if in_app
			let new_file = substitute(new_file, '^app/', '', '')
		end
		let new_file = substitute(new_file, '\.e\?rb$', '_spec.rb', '')
		let new_file = 'spec/' . new_file
	else
		let new_file = substitute(new_file, '_spec\.rb$', '.rb', '')
		let new_file = substitute(new_file, '^spec/', '', '')
		if in_app
			let new_file = 'app/' . new_file
		end
	endif
	return new_file
endfunction
nnoremap <leader>. :call OpenTestAlternate()<cr>
