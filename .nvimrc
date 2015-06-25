
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

call plug#end()

au BufRead,BufNewFile *.hamlc set ft=haml

se t_Co=256
syntax enable
colorscheme grb256

set nobackup
set nowritebackup
set noswapfile
set tabstop=2
set shiftwidth=2
set nu
set clipboard+=unnamedplus

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
