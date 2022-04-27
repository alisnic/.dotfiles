local fn = vim.fn
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
local packer_bootstrap = false

if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
end

-- Load packer.nvim
vim.cmd "packadd packer.nvim"
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]]

require("packer").startup(function(use)
  use "wbthomason/packer.nvim"
  use "tpope/vim-sensible"
  use "tpope/vim-unimpaired"
  use "tpope/vim-sleuth"
  use "google/vim-searchindex"
  use "RRethy/vim-illuminate"
  use "tomtom/tcomment_vim"
  use "majutsushi/tagbar"
  use "tpope/vim-fugitive"
  use "tpope/vim-rhubarb"
  use { "kevinhwang91/nvim-bqf", ft = "qf" }

  use "ellisonleao/gruvbox.nvim"

  use {
    "gfanto/fzf-lsp.nvim",
    config = function()
      vim.keymap.set("n", "<leader>ws", ":WorkspaceSymbol ")
      vim.keymap.set("n", "<leader>m", ":DocumentSymbols<cr>")
    end,
  }

  use {
    "folke/trouble.nvim",
    config = function()
      require("trouble").setup {
        icons = false,
        padding = false,
        auto_open = false,
      }

      vim.cmd [[
        augroup packer_trouble
          autocmd!
          autocmd FileType Trouble setlocal wrap
        augroup end
      ]]
    end,
  }

  use {
    "jose-elias-alvarez/null-ls.nvim",
    requires = {
      { "nvim-lua/plenary.nvim" },
    },
    config = null_ls_setup,
  }

  use {
    "neovim/nvim-lspconfig",
    requires = {
      { "ray-x/lsp_signature.nvim" },
    },
    config = lsp_setup,
  }

  use {
    "dcampos/nvim-snippy",
    config = function()
      require("snippy").setup {
        mappings = {
          is = {
            ["<Tab>"] = "expand_or_advance",
            ["<S-Tab>"] = "previous",
          },
        },
      }
    end,
  }

  use {
    "hrsh7th/nvim-cmp",
    requires = {
      { "onsails/lspkind-nvim" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-cmdline" },
      { "hrsh7th/cmp-emoji" },
      { "f3fora/cmp-spell" },
      { "quangnguyen30192/cmp-nvim-tags" },
    },
    config = cmp_setup,
  }

  use {
    "weilbith/nvim-code-action-menu",
    config = function()
      vim.keymap.set("n", "<leader>ca", ":CodeActionMenu<cr>")
    end,
  }

  use {
    "ishan9299/nvim-solarized-lua",
    config = function()
      vim.cmd "colorscheme gruvbox"
      vim.opt.background = "dark"
    end,
  }

  use {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    requires = {
      { "windwp/nvim-ts-autotag" },
      { "RRethy/nvim-treesitter-endwise" },
    },
    config = treesitter_setup,
  }

  use {
    "tpope/vim-projectionist",
    config = projectionist_setup,
  }

  use "tpope/vim-eunuch"
  use {
    "justinmk/vim-dirvish",
    config = function()
      vim.cmd [[
        let dirvish_mode = ':sort | sort ,^.*/,'

        augroup dirvish
          autocmd!
          autocmd FileType dirvish nnoremap <silent><buffer> r :silent exec "!open %"<cr>
        augroup END
      ]]
    end,
  }

  use {
    "sickill/vim-pasta",
    config = function()
      vim.g.pasta_disabled_filetypes = { "coffee", "yaml", "haml" }
    end,
  }

  use {
    "tommcdo/vim-lion",
    config = function()
      vim.g.lion_squeeze_spaces = 1
    end,
  }

  use {
    "junegunn/fzf.vim",
    requires = { { "/opt/homebrew/opt/fzf" } },
    config = function()
      vim.keymap.set("n", "<leader>f", ":Files<cr>")
      vim.keymap.set("n", "<leader>b", ":Buffers<cr>")
      vim.keymap.set(
        "n",
        "<leader>d",
        [[:call fzf#run(fzf#wrap({'source': "fd -t d"}))<cr>]]
      )
    end,
  }

  use {
    "mileszs/ack.vim",
    config = function()
      vim.g.ackprg = "rg --vimgrep"
      vim.cmd "cabbrev ack Ack!"
    end,
  }

  use {
    "nvim-lualine/lualine.nvim",
    requires = {
      { "arkav/lualine-lsp-progress" },
    },
    config = function()
      require("lualine").setup {
        options = { theme = "gruvbox" },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diagnostics" },
          lualine_c = { "filename", "lsp_progress" },
          lualine_x = {},
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      }
    end,
  }

  if packer_bootstrap then
    require("packer").sync()
  end
end)

function cmp_setup()
  local cmp = require "cmp"
  local lspkind = require "lspkind"

  cmp.setup {
    snippet = {
      expand = function(args)
        require("snippy").expand_snippet(args.body)
      end,
    },
    formatting = {
      format = lspkind.cmp_format {
        with_text = true,
        menu = {
          buffer = "[Buf]",
          tags = "[Tag]",
          nvim_lsp = "[LSP]",
        },
      },
    },
    completion = {
      keyword_length = 2,
    },
    mapping = {
      ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
      ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
      ["<Tab>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "s" }),
      ["<CR>"] = cmp.mapping.confirm { select = false },
    },
    sources = cmp.config.sources({
      { name = "buffer" },
      { name = "nvim_lsp" },
    }, {
      { name = "tags" },
    }),
  }

  cmp.setup.cmdline("/", {
    sources = {
      { name = "buffer" },
    },
  })

  cmp.setup.cmdline(":", {
    sources = cmp.config.sources({
      { name = "path" },
    }, {
      { name = "cmdline" },
    }),
  })

  cmp.setup.filetype("gitcommit", {
    sources = cmp.config.sources({
      { name = "emoji" },
      { name = "spell" },
    }, {
      { name = "buffer" },
    }),
  })
end

function treesitter_setup()
  require("nvim-treesitter.configs").setup {
    highlight = { enable = true },
    endwise = {
      enable = true,
    },
    autotag = {
      enable = true,
      filetypes = { "html", "eruby" },
    },
  }
end

function projectionist_setup()
  local function runInTerminal(cmd)
    if vim.api.nvim_win_get_width(0) > 150 then
      vim.cmd("vsplit | term " .. cmd)
    else
      vim.cmd("tabedit | term " .. cmd)
    end

    vim.cmd "startinsert"
  end

  vim.keymap.set("n", "<leader>a", ":A<cr>")

  vim.keymap.set("n", "<leader>t", function()
    local prg = vim.api.nvim_buf_get_option(0, "makeprg")
    runInTerminal(prg)
  end)

  vim.keymap.set("n", "<leader>r", function()
    local prg = vim.api.nvim_buf_get_option(0, "makeprg")
    runInTerminal(prg .. " --only-failures --fail-fast")
  end)

  vim.keymap.set("n", "<leader>l", function()
    local prg = vim.api.nvim_buf_get_option(0, "makeprg")
    local line = vim.api.nvim_win_get_cursor(0)[1]

    runInTerminal(prg .. ":" .. line)
  end)
end

function null_ls_setup()
  local null_ls = require "null-ls"

  null_ls.setup {
    on_attach = function(client)
      on_attach_callback(client, 1)
    end,
    sources = {
      null_ls.builtins.formatting.prettier.with {
        filetypes = {
          "ruby",
          "typescript",
          "typescriptreact",
          "javascriptreact",
        },
      },
      null_ls.builtins.formatting.stylua.with {
        extra_args = {
          "--config-path",
          vim.fn.expand "~/.config/stylua.toml",
        },
      },
      null_ls.builtins.diagnostics.eslint_d,
      null_ls.builtins.code_actions.eslint_d,
      null_ls.builtins.diagnostics.cspell,
    },
  }
end

function on_attach_callback(client, _)
  require("lsp_signature").on_attach()

  if client.resolved_capabilities.document_formatting then
    vim.api.nvim_command [[augroup Format]]
    vim.api.nvim_command [[autocmd! * <buffer>]]
    vim.api.nvim_command [[autocmd BufWritePost <buffer> lua vim.lsp.buf.formatting()]]
    vim.api.nvim_command [[augroup END]]
  end

  print "LSP Attached."
end

function lsp_setup()
  vim.keymap.set("n", "k", vim.lsp.buf.hover)
  vim.keymap.set("n", "gd", vim.lsp.buf.definition)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation)
  vim.keymap.set("n", "gD", ":vsplit<cr>:lua vim.lsp.buf.definition")
  vim.keymap.set("n", "gr", vim.lsp.buf.references)
  vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename)
  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
  vim.keymap.set("n", "]d", vim.diagnostic.goto_next)

  local capabilities = require("cmp_nvim_lsp").update_capabilities(
    vim.lsp.protocol.make_client_capabilities()
  )

  local servers = { "rust_analyzer", "prismals", "jsonls" }
  for _, lsp in pairs(servers) do
    require("lspconfig")[lsp].setup {
      capabilities = capabilities,
      on_attach = on_attach_callback,
    }
  end

  require("lspconfig").html.setup {
    capabilities = capabilities,
    filetypes = { "html", "eruby" },
    on_attach = function(client, bufnr)
      capabilities.textDocument.completion.completionItem.snippetSupport = true

      if vim.bo.filetype == "eruby" then
        client.resolved_capabilities.document_formatting = false
        client.resolved_capabilities.document_range_formatting = false
      end

      on_attach_callback(client, bufnr)
    end,
  }

  local runtime_path = vim.split(package.path, ";")
  table.insert(runtime_path, "lua/?.lua")
  table.insert(runtime_path, "lua/?/init.lua")

  require("lspconfig").sumneko_lua.setup {
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 200,
    },
    settings = {
      Lua = {
        runtime = {
          version = "LuaJIT",
          path = runtime_path,
        },
        diagnostics = {
          globals = { "vim", "hs" },
          disable = { "lowercase-global" },
        },
        workspace = {
          library = vim.api.nvim_get_runtime_file("", true),
        },
        telemetry = {
          enable = false,
        },
      },
    },
    on_attach = function(client, bufnr)
      client.resolved_capabilities.document_formatting = false
      client.resolved_capabilities.document_range_formatting = false
      on_attach_callback(client, bufnr)
    end,
  }

  require("lspconfig")["solargraph"].setup {
    capabilities = capabilities,
    -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#solargraph
    settings = {
      solargraph = {
        formatting = false,
        diagnostics = false,
        useBundler = false,
        folding = true,
      },
    },
    on_attach = function(client, bufnr)
      client.resolved_capabilities.document_formatting = false
      client.resolved_capabilities.document_range_formatting = false
      on_attach_callback(client, bufnr)
    end,
  }

  require("lspconfig").tsserver.setup {
    capabilities = capabilities,
    on_attach = function(client, bufnr)
      client.resolved_capabilities.document_formatting = false
      client.resolved_capabilities.document_range_formatting = false
      on_attach_callback(client, bufnr)
    end,
  }

  require("lspconfig").yamlls.setup {
    capabilities = capabilities,
    on_attach = on_attach_callback,
    settings = {
      yaml = {
        schemas = {
          kubernetes = "/*.k8s.yaml",
        },
      },
    },
  }
end
