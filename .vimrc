let mapleader = "\<Space>"
let g:loaded_matchparen = 1
let g:loaded_ruby_provider = 1
let g:loaded_node_provider = 1

call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-sensible'
Plug 'tpope/vim-unimpaired'   " awesome pair mappings
Plug 'tpope/vim-sleuth'       " Detect intendation
Plug 'google/vim-searchindex' " show number of search matches
Plug 'RRethy/vim-illuminate'  " Highlight matches for current word under cursor
Plug 'tomtom/tcomment_vim'    " Comment code
Plug 'altercation/vim-colors-solarized'
Plug 'majutsushi/tagbar'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'windwp/nvim-autopairs'
Plug 'jose-elias-alvarez/null-ls.nvim'
Plug 'nvim-lua/plenary.nvim'

" Not supported by nvim-treesitter
Plug 'kchmck/vim-coffee-script'

" Workflow: TDD
let g:term_split = 0
function! RunInTerminal(cmd)
  if has("nvim")
    if g:term_split
      exec("vsplit \| term " . a:cmd)
    else
      exec("tabedit \| term " . a:cmd)
    endif

    startinsert
  else
    exec("tab terminal " . a:cmd)
  endif
endfunction

Plug 'tpope/vim-projectionist'
  nnoremap <leader>a :A<cr>
  nnoremap <leader>t :call RunInTerminal(&makeprg)<cr>
  nnoremap <leader>l :call RunInTerminal(&makeprg . ":" . line('.'))<cr>
  nnoremap <leader>r :call RunInTerminal(&makeprg . " --only-failures --fail-fast")<cr>

" Workflow: Git/Gitlab
Plug 'tpope/vim-fugitive'
Plug 'shumphrey/fugitive-gitlab.vim'
  cabbrev git Git

  if filereadable(expand("~/.vimrc.private"))
    exe 'source ~/.vimrc.private'
  endif

" Workflow: JavaScript
Plug 'prettier/vim-prettier'

" Workflow: File management
Plug 'tpope/vim-eunuch'
Plug 'justinmk/vim-dirvish'
  let dirvish_mode = ':sort | sort ,^.*/,'
  autocmd FileType dirvish nnoremap <silent><buffer> r :silent exec "!open %"<cr>

" Feature: preserve intendation when pasting
Plug 'sickill/vim-pasta'
  let g:pasta_disabled_filetypes = ['coffee', 'yaml', 'haml']

" Feature: align code by characters
Plug 'tommcdo/vim-lion'
  let g:lion_squeeze_spaces = 1

Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
  function! s:switch_project(name)
    execute 'LspStop'
    execute 'cd ~/Work/' . a:name . ' | bufdo bd | Dirvish'
  endfunction

  nnoremap <leader>f :Files<cr>
  nnoremap <leader>b :Buffers<cr>
  nnoremap <silent> <leader>d :call fzf#run(fzf#wrap({'source': 'find . -type d \| grep -v tmp \| grep -v .git'}))<cr>
  nnoremap <silent> <leader>p :call fzf#run(fzf#wrap(
    \ {'source': 'find ~/Work/* -type d -maxdepth 0 \| xargs basename',
    \  'sink': function('<sid>switch_project')}))<cr>

  let g:fzf_preview_window = ''

Plug 'gfanto/fzf-lsp.nvim'
  nnoremap <leader>c :WorkspaceSymbol<cr>
  nnoremap <leader>m :DocumentSymbols<cr>

" Feature: search in all files
function! s:FilterQuickfixList(bang, pattern)
  let cmp = a:bang ? '!~#' : '=~#'
  call setqflist(filter(getqflist(), "bufname(v:val['bufnr']) " . cmp . " a:pattern"))
endfunction

command! -bang -nargs=1 -complete=file Qfilter call s:FilterQuickfixList(<bang>0, <q-args>)

Plug 'mileszs/ack.vim'
  let g:ackprg = 'rg --vimgrep'
  cabbrev ack Ack
  nnoremap <leader>c :Ack<cr>

" Feature: LSP
Plug 'neovim/nvim-lspconfig'
Plug 'ray-x/lsp_signature.nvim'
  nnoremap K  :lua vim.lsp.buf.hover()<cr>
  nnoremap gd :lua vim.lsp.buf.definition()<cr>
  nnoremap gD :vsplit<cr>:lua vim.lsp.buf.definition()<cr>
  nnoremap gr :lua vim.lsp.buf.references()<cr>
  nnoremap <leader>ca :lua vim.lsp.buf.code_action()<cr>

Plug 'folke/trouble.nvim'
  nnoremap <leader>ce :TroubleToggle<cr>

" Feature: autocomplete
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'quangnguyen30192/cmp-nvim-tags'
Plug 'hrsh7th/nvim-cmp'
Plug 'onsails/lspkind-nvim'
  set completeopt=menu,menuone,noselect

call plug#end()

lua <<EOF
  local cmp = require'cmp'
  local lspkind = require('lspkind')
  npairs = require('nvim-autopairs')
  npairs.setup{}
  npairs.add_rules(require('nvim-autopairs.rules.endwise-ruby'))

  require("trouble").setup({ icons = false, padding = false })

  cmp.setup({
    formatting = {
      format = lspkind.cmp_format({
        with_text = true,
        menu = ({
          buffer = "[Buf]",
          tags = "[Tag]",
          nvim_lsp = "[LSP]"
        })
      }),
    },
    completion = {
      keyword_length = 2
    },
    mapping = {
      ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
      ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ["<Tab>"] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' })
    },
    sources = cmp.config.sources({
      { name = 'buffer' },
      { name = 'nvim_lsp' }
    }, {
      { name = 'tags' }
    })
  })

  cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  function dump(o)
     if type(o) == 'table' then
        local s = '{ '
        for k,v in pairs(o) do
           if type(k) ~= 'number' then k = '"'..k..'"' end
           s = s .. '['..k..'] = ' .. dump(v) .. ','
        end
        return s .. '} '
     else
        return tostring(o)
     end
  end

  vim.lsp.handlers["textDocument/formatting"] = function(err, result, ctx)
    local bufnr = ctx['bufnr']

    if err ~= nil or result == nil then
        return
    end
    if not vim.api.nvim_buf_get_option(bufnr, "modified") then
        local view = vim.fn.winsaveview()
        vim.lsp.util.apply_text_edits(result, bufnr)
        vim.fn.winrestview(view)
        if bufnr == vim.api.nvim_get_current_buf() then
            vim.api.nvim_command("noautocmd :update")
        end
    end
  end

  function on_attach_callback(client, bufnr)
    require "lsp_signature".on_attach()

    if client.resolved_capabilities.document_formatting then
        vim.api.nvim_command [[augroup Format]]
        vim.api.nvim_command [[autocmd! * <buffer>]]
        vim.api.nvim_command [[autocmd BufWritePost <buffer> lua vim.lsp.buf.formatting()]]
        vim.api.nvim_command [[augroup END]]
    end

    print("LSP Attached.")
  end

  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  require('lspconfig')['solargraph'].setup {
    capabilities = capabilities,
    -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#solargraph
    settings = { solargraph = { formatting = false, diagnostics = false, useBundler = false, folding = true } },
    on_attach = on_attach_callback
  }

  require('lspconfig').rust_analyzer.setup {
    capabilities = capabilities,
    on_attach = on_attach_callback
  }

  require('lspconfig').tsserver.setup {
    capabilities = capabilities,
    on_attach = function(client, bufnr)
      client.resolved_capabilities.document_formatting = false
      client.resolved_capabilities.document_range_formatting = false
      on_attach_callback(client, bufnr)
    end
  }

  require('lspconfig').prismals.setup {
    capabilities = capabilities,
    on_attach = on_attach_callback
  }

  require('lspconfig').yamlls.setup {
    capabilities = capabilities,
    on_attach = on_attach_callback,
    settings = {
      yaml = {
        schemas = {
          ["/Users/alisnic/.local/schema/k8s-1.20.2-strict/all.json"] = "*.k8s.yaml"
        },
      },
    }
  }

  local runtime_path = vim.split(package.path, ';')
  table.insert(runtime_path, "lua/?.lua")
  table.insert(runtime_path, "lua/?/init.lua")

  require'lspconfig'.sumneko_lua.setup {
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = 'LuaJIT',
          -- Setup your lua path
          path = runtime_path,
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = {'vim'},
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file("", true),
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false,
        },
      },
    },
  }

  null_ls = require("null-ls")
  null_ls.setup({
    on_attach = function(client)
      on_attach_callback(client, 1)
    end,
    sources = {
      null_ls.builtins.diagnostics.rubocop.with({
        command = "bundle",
        args = { "exec", "rubocop", "-f", "json", "--stdin", "$FILENAME" }
      }),
      null_ls.builtins.formatting.prettier
    }
  })
EOF

augroup alisnic
  autocmd!
  autocmd BufWritePre * :%s/\s\+$//e
  autocmd FocusGained * checktime
  autocmd FileType text setlocal modeline
  autocmd FileType ruby,haml setlocal tags+=.git/rubytags | setlocal tags-=.git/tags
augroup END

colorscheme solarized
set background=light

set title
set titlestring=%f
set laststatus=0
set mouse=a
set splitright
set hidden
set clipboard=unnamed
set winwidth=78
set virtualedit=block
set synmaxcol=200

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
set foldmethod=indent

set tags+=.git/tags " ,~/.rubies/ruby-2.4.6/tags,~/src/ruby-2.4.6/tags
set tagcase=match
nnoremap <leader>] :exec("tabedit \| tag ".expand("<cword>"))<CR>

nnoremap <S-UP> <C-w><UP>
nnoremap <S-Down> <C-w><Down>
nnoremap <S-Left> <C-w><Left>
nnoremap <S-Right> <C-w><Right>
nnoremap <leader>1 1gt
nnoremap <leader>2 2gt
nnoremap <leader>3 3gt
nnoremap <UP> gk
nnoremap <Down> gj

command! Scratch :exe "e " . "~/.notes/scratch/" . strftime('%Y-%m-%d') . ".txt"
command! Focus :exe "normal! zMzv"

" I do a lot of shift typos, these are the most common ones
command! W w
command! Wq wq
vnoremap <S-UP> <nop>
vnoremap <S-Down> <nop>
