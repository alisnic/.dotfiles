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
  use "tpope/vim-sleuth"
  use "tpope/vim-rhubarb"
  use "tpope/vim-commentary"
  use "google/vim-searchindex"
  use "kchmck/vim-coffee-script"
  use "folke/neodev.nvim"
  use "michaeljsmith/vim-indent-object"
  use "stevearc/dressing.nvim"
  use {
    "seblj/nvim-tabline",
    requires = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("tabline").setup {
        no_name = "[No Name]", -- Name for buffers with no name
        modified_icon = "", -- Icon for showing modified buffer
        close_icon = "", -- Icon for closing tab with mouse
        separator = "▌", -- Separator icon on the left side
        padding = 1, -- Prefix and suffix space
        color_all_icons = false, -- Color devicons in active and inactive tabs
        right_separator = false, -- Show right separator on the last tab
        show_index = false, -- Shows the index of tab before filename
        show_icon = true, -- Shows the devicon
      }

      vim.cmd "hi! link TabLineSeparatorSel TabLineSeparator"
    end,
  }

  use {
    "chrisgrieser/nvim-early-retirement",
    config = function()
      require("early-retirement").setup {
        retirementAgeMins = 60,
        minimumBufferNum = 5,
        ignoredFiletypes = { "markdown" },
      }
    end,
  }

  use {
    "lukas-reineke/lsp-format.nvim",
    config = function()
      require("lsp-format").setup {}
    end,
  }

  use {
    "folke/flash.nvim",
    config = function()
      require("flash").setup {
        highlight = {
          groups = {
            match = "Question",
          },
        },
        modes = { char = { enabled = false }, search = { enabled = false } },
      }

      vim.keymap.set("n", "s", function()
        require("flash").jump {
          search = {
            mode = function(str)
              return "\\<" .. str
            end,
          },
        }
      end, { silent = true })
    end,
  }

  use {
    "nvim-tree/nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").setup()
    end,
  }

  use {
    "folke/noice.nvim",
    requires = {
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("noice").setup {
        lsp = {
          signature = {
            enabled = true,
            auto_open = {
              enabled = false,
            },
          },
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
          },
        },
        presets = {
          lsp_doc_border = true,
        },
      }
    end,
  }

  use {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup {
        "scss",
        "less",
      }
    end,
  }

  use {
    "tpope/vim-unimpaired",
    config = function()
      vim.keymap.set("n", "[L", ":lolder<cr>", { silent = true })
      vim.keymap.set("n", "]L", ":lnewer<cr>", { silent = true })
      vim.keymap.set("n", "[Q", ":colder<cr>", { silent = true })
      vim.keymap.set("n", "]Q", ":cnewer<cr>", { silent = true })
    end,
  }

  use {
    "nvim-telescope/telescope.nvim",
    config = function()
      local actions = require "telescope.actions"

      require("telescope").setup {
        defaults = {
          layout_strategy = "vertical",
          layout_config = { width = 0.9, height = 0.9 },
          mappings = {
            i = {
              ["<esc>"] = actions.close,
              -- ["<tab>"] = actions.select_default,
            },
            -- commands = {
            -- },
          },
        },
      }

      vim.keymap.set(
        "n",
        "<leader>f",
        ":Telescope git_files show_untracked=true<cr>",
        { silent = true }
      )
      vim.keymap.set(
        "n",
        "<leader>t",
        ":Telescope commands<cr>",
        { silent = true }
      )
      vim.keymap.set(
        "n",
        "<leader>ld",
        ":Telescope diagnostics bufnr=0<cr>",
        { silent = true }
      )
      vim.keymap.set(
        "n",
        "<leader>p",
        ":Telescope find_files hidden=true<cr>",
        { silent = true }
      )
      vim.keymap.set(
        "n",
        "<leader>b",
        ":Telescope buffers sort_mru=true<cr>",
        { silent = true }
      )

      vim.keymap.set(
        "n",
        "<leader>m",
        ":Telescope lsp_document_symbols<cr>",
        { silent = true }
      )
      vim.keymap.set(
        "n",
        "<leader>w",
        ":Telescope lsp_dynamic_workspace_symbols fname_width=100<cr>",
        { silent = true }
      )
      vim.keymap.set(
        "n",
        "<leader>h",
        ":Telescope help_tags<cr>",
        { silent = true }
      )
    end,
  }

  use {
    "tpope/vim-fugitive",
    config = function()
      vim.cmd "command! Blame :Git blame"

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
    "NeogitOrg/neogit",
    config = function()
      local neogit = require "neogit"
      neogit.setup {
        disable_context_highlighting = true,
        disable_commit_confirmation = true,
        disable_signs = true,
        integrations = { telescope = true },
        mappings = {
          popup = {
            ["Z"] = false,
          },
        },
      }

      vim.keymap.set("n", "<leader>g", ":Neogit<cr>", { silent = true })
    end,
  }

  use {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    config = function()
      require("bqf").setup {
        preview = {
          winblend = 0,
        },
      }
    end,
  }

  use {
    "ellisonleao/gruvbox.nvim",
    config = function()
      require("gruvbox").setup {
        bold = false,
      }

      vim.cmd [[
         hi! link NoiceCmdlinePopupBorder PopupBorder
      ]]
    end,
  }

  use {
    "jose-elias-alvarez/null-ls.nvim",
    requires = {
      { "nvim-lua/plenary.nvim" },
    },
    config = function()
      local null_ls = require "null-ls"

      null_ls.setup {}
      null_ls.register {
        null_ls.builtins.formatting.stylua.with {
          extra_args = {
            "--config-path",
            vim.fn.expand "~/.config/stylua.toml",
          },
        },
      }
    end,
  }

  use {
    "neovim/nvim-lspconfig",
    requires = {
      { "yioneko/nvim-vtsls" },
      { "pmizio/typescript-tools.nvim" },
    },
    config = function()
      lsp_setup()
    end,
  }

  use {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup {
        suggestion = { enabled = false },
        panel = { enabled = false },
      }
    end,
  }

  use {
    "zbirenbaum/copilot-cmp",
    after = { "copilot.lua" },
    config = function()
      require("copilot_cmp").setup {
        formatters = {
          insert_text = require("copilot_cmp.format").remove_existing,
        },
      }
    end,
  }

  use {
    "hrsh7th/nvim-cmp",
    requires = {
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-cmdline" },
      { "hrsh7th/cmp-emoji" },
      { "quangnguyen30192/cmp-nvim-tags" },
      { "saadparwaiz1/cmp_luasnip" },
      { "onsails/lspkind-nvim" },
    },
    config = function()
      cmp_setup()
    end,
  }

  use {
    "JoosepAlviste/nvim-ts-context-commentstring",
    config = function()
      vim.g.skip_ts_context_commentstring_module = true
    end,
  }

  use {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    requires = {
      { "windwp/nvim-ts-autotag" },
      { "RRethy/nvim-treesitter-endwise" },
      { "nvim-treesitter/playground" },
    },
    config = function()
      treesitter_setup()
    end,
  }

  use {
    "nvim-treesitter/nvim-treesitter-context",
    config = function()
      local ts_context = require "treesitter-context"
      ts_context.setup { max_lines = 3 }

      vim.keymap.set("n", "[c", function()
        ts_context.go_to_context()
      end, { silent = true })
    end,
  }

  use {
    "lewis6991/spellsitter.nvim",
    config = function()
      require("spellsitter").setup()
    end,
  }

  use {
    "tpope/vim-projectionist",
    config = function()
      vim.keymap.set("n", "<leader>a", ":A<cr>", { silent = true })
    end,
  }

  use "tpope/vim-eunuch"
  use {
    "tamago324/lir.nvim",
    requires = {
      { "nvim-lua/plenary.nvim" },
    },
    config = function()
      local actions = require "lir.actions"

      require("lir").setup {
        show_hidden_files = true,
        devicons = {
          enable = true,
          highlight_dirname = false,
        },
        mappings = {
          ["<cr>"] = actions.edit,
          ["<C-s>"] = actions.split,
          ["<C-v>"] = actions.vsplit,
          ["<C-t>"] = actions.tabedit,
          ["-"] = actions.up,
          ["q"] = actions.quit,
          ["K"] = actions.mkdir,
          ["N"] = actions.newfile,
          ["R"] = actions.rename,
          ["Y"] = actions.yank_path,
          ["."] = actions.toggle_show_hidden,
          ["D"] = actions.delete,
          ["o"] = function()
            vim.cmd [[ !open % ]]
          end,
        },
      }

      vim.api.nvim_set_keymap(
        "n",
        "-",
        [[<Cmd>execute 'e ' .. expand('%:p:h')<CR>]],
        { noremap = true }
      )
    end,
  }

  use {
    "sickill/vim-pasta",
    config = function()
      vim.g.pasta_disabled_filetypes = { "coffee", "yaml", "haml" }
    end,
  }

  use {
    "mileszs/ack.vim",
    config = function()
      vim.g.ackprg = "rg --vimgrep -F"
      vim.cmd "cabbrev ack Ack!"
    end,
  }

  use {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("statusline").setup()
    end,
  }

  use {
    "b0o/incline.nvim",
    config = function()
      require("incline").setup {
        debounce_threshold = { falling = 500, rising = 250 },
        window = { padding = 0, margin = { horizontal = 0 } },
        hide = { focused_win = true },
      }
    end,
  }

  use {
    "L3MON4D3/LuaSnip",
    config = function()
      require("luasnip").config.set_config {
        history = false,
        delete_check_events = "InsertLeave",
      }
      require("luasnip.loaders.from_vscode").load {
        paths = vim.fn.stdpath "config" .. "/snippets",
      }

      vim.cmd [[
        augroup luasnip_alisnic
          autocmd!
          autocmd InsertLeave * silent! LuaSnipUnlinkCurrent
        augroup end
      ]]
    end,
  }

  if packer_bootstrap then
    require("packer").sync()
  end
end)

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0
    and vim.api
        .nvim_buf_get_lines(0, line - 1, line, true)[1]
        :sub(col, col)
        :match "%s"
      == nil
end

function cmp_setup()
  local cmp = require "cmp"
  local lspkind = require "lspkind"
  local luasnip = require "luasnip"
  local cmp_buffer = require "cmp_buffer"

  cmp.setup {
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    window = {
      documentation = cmp.config.window.bordered(),
      completion = cmp.config.window.bordered(),
    },
    formatting = {
      format = lspkind.cmp_format {
        mode = "text_icon",
      },
    },
    performance = {
      -- max_view_entries = 10,
      debounce = 200,
    },
    completion = {
      keyword_length = 2,
    },
    mapping = {
      ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
      ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_locally_jumpable() then
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

      ["<CR>"] = function(fallback)
        -- Don't block <CR> if signature help is active
        -- https://github.com/hrsh7th/cmp-nvim-lsp-signature-help/issues/13
        if
          not cmp.visible()
          or not cmp.get_selected_entry()
          or cmp.get_selected_entry().source.name == "nvim_lsp_signature_help"
        then
          fallback()
        else
          cmp.confirm {
            -- Replace word if completing in the middle of a word
            -- https://github.com/hrsh7th/nvim-cmp/issues/664
            behavior = cmp.ConfirmBehavior.Replace,
            -- Don't select first item on CR if nothing was selected
            select = false,
          }
        end
      end,
    },
    sources = cmp.config.sources({
      { name = "luasnip" },
      { name = "copilot" },
      { name = "nvim_lsp" },
    }, {
      {
        name = "buffer",
        option = {
          get_bufnrs = function()
            local bufs = {}
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              bufs[vim.api.nvim_win_get_buf(win)] = true
            end
            return vim.tbl_keys(bufs)
          end,
        },
      },
    }),
    experimental = { ghost_text = true },
  }

  cmp.setup.cmdline("/", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = "buffer" },
    },
  })

  cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = "path" },
    }, {
      { name = "cmdline" },
    }),
  })

  cmp.setup.filetype({ "gitcommit", "NeogitCommitMessage" }, {
    sources = cmp.config.sources {
      { name = "buffer" },
      { name = "emoji" },
    },
  })

  cmp.setup.filetype("markdown", { sources = { { name = "buffer" } } })
end

function treesitter_setup()
  require("nvim-treesitter.configs").setup {
    highlight = { enable = true },
    endwise = {
      enable = true,
    },
    indent = {
      enable = true,
    },
    autotag = {
      enable = true,
      filetypes = { "html", "eruby", "javascriptreact", "typescriptreact" },
    },
  }
end

function lsp_setup()
  vim.keymap.set("n", "<leader>k", vim.lsp.buf.hover)
  vim.keymap.set("n", "<leader>e", function()
    vim.diagnostic.open_float(
      nil,
      { focus = false, scope = "cursor", border = "rounded" }
    )
  end)
  vim.keymap.set("n", "gd", vim.lsp.buf.definition)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation)
  vim.keymap.set("n", "gD", ":vsplit<cr>:lua vim.lsp.buf.definition()<cr>")
  vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help)
  vim.keymap.set("n", "gr", vim.lsp.buf.references)
  vim.keymap.set("n", "gR", ":vsplit<cr>:lua vim.lsp.buf.references()<cr>")
  vim.keymap.set("n", "[d", function()
    vim.diagnostic.goto_prev { severity = { min = vim.diagnostic.severity.WARN } }
  end)
  vim.keymap.set("n", "]d", function()
    vim.diagnostic.goto_next { severity = { min = vim.diagnostic.severity.WARN } }
  end)
  vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename)
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)
  vim.keymap.set("n", "<leader>lt", vim.lsp.buf.type_definition)

  local capabilities = require("cmp_nvim_lsp").default_capabilities()
  local lspconfig = require "lspconfig"

  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      client.server_capabilities.semanticTokensProvider = nil
    end,
  })

  require("neodev").setup()

  require("lspconfig.configs").vtsls = require("vtsls").lspconfig
  -- vim.cmd "command! RemoveUnusedImports :VtsExec remove_unused_imports"

  vim.keymap.set("n", "gs", ":VtsExec goto_source_definition<cr>")

  -- lspconfig.vtsls.setup {
  --   capabilities = capabilities,
  --   on_attach = function(client, bufnr)
  --     client.server_capabilities.documentFormattingProvider = false
  --     client.server_capabilities.documentRangeFormattingProvider = false
  --     client.server_capabilities.semanticTokensProvider = false
  --   end,
  --   settings = {
  --     typescript = { preferences = { includePackageJsonAutoImports = "off" } },
  --     vtsls = { experimental = { completion = { entriesLimit = 50 } } },
  --   },
  -- }
  require("typescript-tools").setup {
    capabilities = capabilities,
    on_attach = function(client, bufnr)
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end,
    settings = {
      -- spawn additional tsserver instance to calculate diagnostics on it
      separate_diagnostic_server = false,
    },
  }

  local util = require "lspconfig.util"
  local configs = require "lspconfig.configs"

  lspconfig.lua_ls.setup {
    capabilities = capabilities,
    on_attach = function(client)
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end,
    settings = {
      Lua = {
        completion = {
          callSnippet = "Replace",
        },
        workspace = { checkThirdParty = false },
      },
    },
  }

  configs.oxc_language_server = {
    default_config = {
      cmd = {
        "/Users/andreilisnic/Work/oxc/editors/vscode/target/release/oxc_language_server",
      },
      filetypes = {
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
      },
      root_dir = function(fname)
        return util.find_package_json_ancestor(fname)
          or util.find_node_modules_ancestor(fname)
          or util.find_git_ancestor(fname)
      end,
      settings = {
        ["enable"] = true,
        -- ["run"] = "onType",
      },
    },
  }

  lspconfig.oxc_language_server.setup {
    capabilities = capabilities,
    on_attach = function(client, bufnr)
      client.server_capabilities.semanticTokensProvider = nil
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end,
  }
end
