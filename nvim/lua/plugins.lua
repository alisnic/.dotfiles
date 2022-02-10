local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
local packer_bootstrap = false

if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

-- Load packer.nvim
vim.cmd("packadd packer.nvim")
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

function on_attach_callback(client, _)
  require("lsp_signature").on_attach()

  if client.resolved_capabilities.document_formatting then
      vim.api.nvim_command [[augroup Format]]
      vim.api.nvim_command [[autocmd! * <buffer>]]
      vim.api.nvim_command [[autocmd BufWritePost <buffer> lua vim.lsp.buf.formatting()]]
      vim.api.nvim_command [[augroup END]]
  end

  print("LSP Attached.")
end

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'tpope/vim-sensible'
  use 'tpope/vim-unimpaired'
  use 'tpope/vim-sleuth'
  use 'google/vim-searchindex'
  use 'RRethy/vim-illuminate'
  use 'tomtom/tcomment_vim'
  use 'majutsushi/tagbar'
  use 'windwp/nvim-autopairs'
  use 'tpope/vim-fugitive'

  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use {
    'RRethy/nvim-treesitter-endwise',
    config = function()
      require('nvim-treesitter.configs').setup {
          highlight = { enable = true },
          endwise = {
              enable = true,
          },
      }
    end
  }

  use {
    'tpope/vim-projectionist',
    config = function()
      local util = require('util')
      local function runInTerminal(cmd)
        if vim.api.nvim_win_get_width(0) > 150 then
          vim.cmd("vsplit | term " .. cmd)
        else
          vim.cmd("tabedit | term " .. cmd)
        end

        vim.cmd("startinsert")
      end

      util.nmap('<leader>a', ':A<cr>')

      util.nmap_func('<leader>t', function()
        local prg = vim.api.nvim_buf_get_option(0, 'makeprg')
        runInTerminal(prg)
      end)

      util.nmap_func('<leader>r', function()
        local prg = vim.api.nvim_buf_get_option(0, 'makeprg')
        runInTerminal(prg .. " --only-failures --fail-fast")
      end)

      util.nmap_func('<leader>l', function()
        local prg  = vim.api.nvim_buf_get_option(0, 'makeprg')
        local line = vim.api.nvim_win_get_cursor(0)[1]

        runInTerminal(prg .. ":" .. line)
      end)
    end
  }

  use {
    'altercation/vim-colors-solarized',
    config = function()
      vim.cmd('colorscheme solarized')
      vim.opt.background = 'light'
    end
  }

  use 'tpope/vim-eunuch'
  use {
    'justinmk/vim-dirvish',
    config = function()
      vim.cmd([[
        let dirvish_mode = ':sort | sort ,^.*/,'

        augroup dirvish
          autocmd!
          autocmd FileType dirvish nnoremap <silent><buffer> r :silent exec "!open %"<cr>
        augroup END
      ]])
    end
  }

  use {
    'sickill/vim-pasta',
    config = function()
      vim.g.pasta_disabled_filetypes = {'coffee', 'yaml', 'haml'}
    end
  }

  use {
    'tommcdo/vim-lion',
    config = function ()
      vim.g.lion_squeeze_spaces = 1
    end
  }

  use {
    'junegunn/fzf.vim',
    requires = {{ '/usr/local/opt/fzf' }},
    config = function()
      vim.g.fzf_preview_window = ''

      local util = require('util')
      util.nmap('<leader>f', ':Files<cr>')
      util.nmap('<leader>b', ':Buffers<cr>')
      util.nmap('<leader>d', [[:call fzf#run(fzf#wrap({'source': "git ls-files | xargs -n 1 dirname | sort | uniq"}))<cr>]])
    end
  }

  use {
    'gfanto/fzf-lsp.nvim',
    config = function()
      local util = require('util')
      util.nmap('<leader>c', ':WorkspaceSymbol<cr>')
      util.nmap('<leader>m', ':DocumentSymbols<cr>')
    end
  }

  use {
    'mileszs/ack.vim',
    config = function()
      vim.g.ackprg = 'rg --vimgrep'
      vim.cmd('cabbrev ack Ack')

      local util = require('util')
      util.nmap('<leader>c', ':Ack<cr>')
    end
  }

  use {
    'ray-x/lsp_signature.nvim',
    config = function ()
      local util = require('util')
      util.nmap('K',  ':lua vim.lsp.buf.hover()<cr>')
      util.nmap('gd', ':lua vim.lsp.buf.definition()<cr>')
      util.nmap('gD', ':vsplit<cr>:lua vim.lsp.buf.definition()<cr>')
      util.nmap('gr', ':lua vim.lsp.buf.references()<cr>')
      util.nmap('<leader>ca', ':lua vim.lsp.buf.code_action()<cr>')
    end
  }

  use {
    'folke/trouble.nvim',
    config = function ()
      require("trouble").setup({
        icons = false,
        padding = false,
        auto_open = true
      })

      vim.cmd([[
        augroup packer_trouble
          autocmd!
          autocmd FileType Trouble setlocal wrap
        augroup end
      ]])
    end
  }

  use {
    'jose-elias-alvarez/null-ls.nvim',
    requires = {{ 'nvim-lua/plenary.nvim' }},
    config = function()
      local null_ls = require("null-ls")

      null_ls.setup({
        on_attach = function(client)
          on_attach_callback(client, 1)
        end,
        sources = {
          -- null_ls.builtins.diagnostics.rubocop.with({
          --   command = "bundle",
          --   args = { "exec", "rubocop", "-f", "json", "--stdin", "$FILENAME" }
          -- }),
          null_ls.builtins.formatting.prettier
        }
      })
    end
  }

  use {
    'neovim/nvim-lspconfig',
    config = function()
      local capabilities = require('cmp_nvim_lsp').update_capabilities(
        vim.lsp.protocol.make_client_capabilities()
      )

      local servers = { 'rust_analyzer', 'prismals' }
      for _, lsp in pairs(servers) do
        require('lspconfig')[lsp].setup {
          capabilities = capabilities,
          on_attach = on_attach_callback
        }
      end

      local runtime_path = vim.split(package.path, ';')
      table.insert(runtime_path, "lua/?.lua")
      table.insert(runtime_path, "lua/?/init.lua")

      require('lspconfig').sumneko_lua.setup {
        capabilities = capabilities,
        flags = {
          debounce_text_changes = 200,
        },
        settings = {
          Lua = {
            runtime = {
              version = 'LuaJIT',
              path = runtime_path,
            },
            diagnostics = {
              globals = {'vim', 'hs'},
              disable = {"lowercase-global"}
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
            },
            telemetry = {
              enable = false,
            },
          },
        },
      }

      require('lspconfig')['solargraph'].setup {
        capabilities = capabilities,
        -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#solargraph
        settings = { solargraph = { formatting = false, diagnostics = false, useBundler = false, folding = true } },
        on_attach = function(client, bufnr)
          client.resolved_capabilities.document_formatting = false
          client.resolved_capabilities.document_range_formatting = false
          on_attach_callback(client, bufnr)
        end
      }

      require('lspconfig').tsserver.setup {
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          client.resolved_capabilities.document_formatting = false
          client.resolved_capabilities.document_range_formatting = false
          on_attach_callback(client, bufnr)
        end
      }

      require('lspconfig').yamlls.setup {
        capabilities = capabilities,
        on_attach = on_attach_callback,
        settings = {
          yaml = {
            schemas = {
              kubernetes = "/*.k8s.yaml"
            },
          },
        }
      }
    end
  }

  use {
    'hrsh7th/nvim-cmp',
    requires = {
      { 'onsails/lspkind-nvim' },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-path' },
      { 'hrsh7th/cmp-cmdline' },
      { 'quangnguyen30192/cmp-nvim-tags' }
    },
    config = function ()
      local cmp = require'cmp'
      local lspkind = require('lspkind')

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

      cmp.setup.cmdline('/', {
        sources = {
          { name = 'buffer' }
        }
      })

      cmp.setup.cmdline(':', {
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          { name = 'cmdline' }
        })
      })
    end
  }

  if packer_bootstrap then
    require('packer').sync()
  end
end)

