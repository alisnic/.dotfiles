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
  use "tpope/vim-unimpaired"
  use "tpope/vim-sleuth"
  use "tpope/vim-rhubarb"
  use "tpope/vim-commentary"
  use "google/vim-searchindex"
  use "RRethy/vim-illuminate"
  use "stevearc/dressing.nvim"
  use "kchmck/vim-coffee-script"
  use "folke/lua-dev.nvim"

  use {
    "nvim-telescope/telescope.nvim",
    config = function()
      local actions = require "telescope.actions"

      require("telescope").setup {
        defaults = {
          layout_strategy = "vertical",
          mappings = {
            i = {
              ["<esc>"] = actions.close,
            },
          },
        },
      }

      vim.keymap.set("n", "<leader>f", ":Telescope find_files<cr>")
      vim.keymap.set("n", "<leader>b", ":Telescope buffers<cr>")
      vim.keymap.set("n", "<leader>m", ":Telescope lsp_document_symbols<cr>")
      vim.keymap.set(
        "n",
        "<leader>w",
        ":Telescope lsp_dynamic_workspace_symbols<cr>"
      )
    end,
  }

  use {
    "tpope/vim-fugitive",
    config = function()
      vim.cmd [[
        cabbrev git Git
        augroup packer_fugitive
          autocmd!
          autocmd FileType fugitiveblame nmap <silent><buffer> q gq
        augroup end
      ]]
    end,
  }

  use {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    config = function()
      vim.cmd [[
        augroup packer_bqf
          autocmd!
          autocmd FileType qf nnoremap <silent><buffer> q :cclose<cr>
          autocmd FileType qf nnoremap <slient><buffer> [f :colder<cr>
          autocmd FileType qf nnoremap <slient><buffer> ]f :cnewer<cr>
        augroup end
      ]]
    end,
  }

  use {
    "nvim-pack/nvim-spectre",
    config = function()
      vim.keymap.set("n", "<leader>s", require("spectre").open)
    end,
  }

  use {
    "ellisonleao/gruvbox.nvim",
    config = function()
      vim.g.gruvbox_bold = 0
      vim.g.gruvbox_contrast_dark = "medium"
      vim.cmd "colorscheme gruvbox"
      vim.opt.background = "dark"
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
    config = function()
      null_ls_setup()
    end,
  }

  use {
    "neovim/nvim-lspconfig",
    requires = {
      { "ray-x/lsp_signature.nvim" },
    },
    config = function()
      lsp_setup()
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
      { "quangnguyen30192/cmp-nvim-tags" },
      { "saadparwaiz1/cmp_luasnip" },
    },
    config = function()
      cmp_setup()
    end,
  }

  use {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    requires = {
      { "windwp/nvim-ts-autotag" },
      { "RRethy/nvim-treesitter-endwise" },
      { "nvim-treesitter/nvim-treesitter-textobjects" },
      { "JoosepAlviste/nvim-ts-context-commentstring" },
    },
    config = function()
      treesitter_setup()
    end,
  }

  use {
    "tpope/vim-projectionist",
    config = function()
      vim.keymap.set("n", "<leader>a", ":A<cr>")
    end,
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
    "mileszs/ack.vim",
    config = function()
      vim.g.ackprg = "rg --vimgrep"
      vim.cmd "cabbrev ack Ack!"
    end,
  }

  use {
    "ray-x/lsp_signature.nvim",
    config = function()
      require("lsp_signature").setup { hint_enable = false }
    end,
  }

  use {
    "j-hui/fidget.nvim",
    config = function()
      require("fidget").setup {}
    end,
  }

  use {
    "nvim-lualine/lualine.nvim",
    requires = {
      { "SmiteshP/nvim-gps" },
    },
    config = function()
      local gps = require "nvim-gps"
      gps.setup()

      require("lualine").setup {
        options = { theme = "gruvbox", globalstatus = true },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diagnostics" },
          lualine_c = { "filename" },
          lualine_x = { { gps.get_location, cond = gps.is_available } },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      }
    end,
  }

  use {
    "L3MON4D3/LuaSnip",
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  }
  use "rafamadriz/friendly-snippets"

  if packer_bootstrap then
    require("packer").sync()
  end
end)

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0
    and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]
        :sub(col, col)
        :match "%s"
      == nil
end

function cmp_setup()
  local cmp = require "cmp"
  local lspkind = require "lspkind"
  local luasnip = require "luasnip"

  cmp.setup {
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    window = {
      documentation = cmp.config.window.bordered(),
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

      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end, { "i", "s" }),

      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { "i", "s" }),

      ["<CR>"] = cmp.mapping.confirm { select = false },
    },
    sources = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "luasnip" },
      { name = "buffer" },
    }, {
      { name = "tags" },
    }),
    experimental = { ghost_text = true },
  }

  cmp.setup.cmdline("/", {
    sources = {
      { name = "buffer" },
    },
  })

  cmp.setup.cmdline(":", {
    sources = cmp.config.sources {
      { name = "cmdline" },
      { name = "path" },
    },
  })

  cmp.setup.filetype("gitcommit", {
    sources = cmp.config.sources {
      { name = "buffer" },
      { name = "emoji" },
    },
  })
end

function treesitter_setup()
  require("nvim-treesitter.configs").setup {
    highlight = { enable = true },
    context_commentstring = {
      enable = true,
    },
    endwise = {
      enable = true,
    },
    autotag = {
      enable = true,
      filetypes = { "html", "eruby" },
    },
    textobjects = {
      lsp_interop = {
        enable = true,
        border = "none",
        peek_definition_code = {
          ["gp"] = "@function.outer",
        },
      },
    },
  }
end

function null_ls_setup()
  local null_ls = require "null-ls"

  null_ls.setup {
    on_attach = function(client)
      _G.on_attach_callback(client, 1)
    end,
    sources = {
      null_ls.builtins.formatting.prettier.with {
        filetypes = {
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
    },
  }
end

function _G.on_attach_callback(client, _)
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
  vim.keymap.set("n", "K", function()
    vim.diagnostic.open_float(nil, { focus = false })
  end)
  vim.keymap.set("n", "gd", vim.lsp.buf.definition)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation)
  vim.keymap.set("n", "gD", ":vsplit<cr>:lua vim.lsp.buf.definition()<cr>")
  vim.keymap.set("n", "gr", vim.lsp.buf.references)
  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
  vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
  vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename)
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)

  local capabilities = require("cmp_nvim_lsp").update_capabilities(
    vim.lsp.protocol.make_client_capabilities()
  )

  local servers = { "rust_analyzer" }
  for _, lsp in pairs(servers) do
    require("lspconfig")[lsp].setup {
      capabilities = capabilities,
      on_attach = _G.on_attach_callback,
    }
  end

  require("lspconfig").tsserver.setup {
    capabilities = capabilities,
    on_attach = function(client, bufnr)
      client.resolved_capabilities.document_formatting = false
      client.resolved_capabilities.document_range_formatting = false
      _G.on_attach_callback(client, bufnr)
    end,
  }
end
