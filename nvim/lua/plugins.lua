local fn = vim.fn

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0
    and vim.api
        .nvim_buf_get_lines(0, line - 1, line, true)[1]
        :sub(col, col)
        :match "%s"
      == nil
end

local function lsp_diagnostic_status()
  local lsp = require "lsp"
  local diagnostics = lsp.current_line_diagnostics()
  local best = lsp.best_diagnostic(diagnostics)

  local message = lsp.format_diagnostic(best)
  local max_width = vim.api.nvim_list_uis()[1].width - 35

  if string.len(message) < max_width then
    return message
  else
    return string.sub(message, 1, max_width) .. "..."
  end
end

function lualine_setup()
  require("lualine").setup {
    options = {
      theme = "gruvbox",
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch" },
      lualine_c = {
        {
          lsp_diagnostic_status,
        },
      },
      lualine_x = {},
      lualine_y = {
        "filename",
        "diagnostics",
      },
      lualine_z = { "location" },
    },
  }
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
    indent = {
      enable = true,
    },
    autotag = {
      enable = true,
      filetypes = { "html", "eruby" },
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
  vim.keymap.set("n", "[d", function()
    vim.diagnostic.goto_prev { severity = vim.diagnostic.severity.ERROR }
  end)
  vim.keymap.set("n", "]d", function()
    vim.diagnostic.goto_next { severity = vim.diagnostic.severity.ERROR }
  end)
  vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename)
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)
  vim.keymap.set("n", "<leader>lt", vim.lsp.buf.type_definition)

  local capabilities = require("cmp_nvim_lsp").default_capabilities()
  local lspconfig = require "lspconfig"

  require("neodev").setup()

  require("lspconfig.configs").vtsls = require("vtsls").lspconfig
  vim.cmd "command! RemoveUnusedImports :VtsExec remove_unused_imports"

  lspconfig.vtsls.setup {
    capabilities = capabilities,
    on_attach = function(client, bufnr)
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end,
  }

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
      -- completion = cmp.config.window.bordered(),
    },
    formatting = {
      format = lspkind.cmp_format {
        mode = "text_icon",
      },
    },
    performance = {
      max_view_entries = 10,
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
    -- sorting = {
    --   comparators = {
    --     cmp.config.compare.order,
    --     cmp.config.compare.locality,
    --   },
    -- },
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


require("lazy").setup({
  "wbthomason/packer.nvim",
  "tpope/vim-sleuth",
  "tpope/vim-rhubarb",
  "tpope/vim-commentary",
  "google/vim-searchindex",
  "kchmck/vim-coffee-script",
  "folke/neodev.nvim",
  "michaeljsmith/vim-indent-object",
  "stevearc/dressing.nvim",

  {
    "chrisgrieser/nvim-early-retirement",
    config = function()
      require("early-retirement").setup {
        retirementAgeMins = 60,
        minimumBufferNum = 5,
        ignoredFiletypes = { "markdown" },
      }
    end,
  },

  {
    "lukas-reineke/lsp-format.nvim",
    config = function()
      require("lsp-format").setup {}
    end,
  },

  {
    "folke/flash.nvim",
    config = function()
      require("flash").setup {
        highlight = {
          groups = {
            match = "Question",
          },
        },
        modes = { char = { enabled = false } },
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
  },

  {
    "nvim-tree/nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").setup()
    end,
  },

  {
    "RRethy/vim-illuminate",
    config = function()
      require("illuminate").configure {
        providers = {
          -- "lsp",
          "treesitter",
        },
        under_cursor = false,
        filetypes_denylist = {
          "fugitive",
          "qf",
          "NeogitStatus",
        },
        min_count_to_highlight = 2,
      }

      -- vim.cmd [[
      --   hi! IlluminatedWordText gui=undercurl
      --   hi! IlluminatedWordRead gui=undercurl
      --   hi! IlluminatedWordWrite gui=undercurl
      -- ]]
    end,
  },

  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
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
  },

  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup {
        "scss",
        "less",
      }
    end,
  },

  {
    "tpope/vim-unimpaired",
    config = function()
      vim.keymap.set("n", "[L", ":lolder<cr>", { silent = true })
      vim.keymap.set("n", "]L", ":lnewer<cr>", { silent = true })
      vim.keymap.set("n", "[Q", ":colder<cr>", { silent = true })
      vim.keymap.set("n", "]Q", ":cnewer<cr>", { silent = true })
    end,
  },

  {
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
            },
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
  },

  {
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
  },

  {
    "NeogitOrg/neogit",
    commit = "00b4486197e7ad7cf98e128a3c663d79a2cc962f",
    config = function()
      local neogit = require "neogit"
      neogit.setup {
        disable_context_highlighting = true,
        disable_commit_confirmation = true,
        disable_signs = true,
        integrations = { telescope = true },
      }

      vim.keymap.set("n", "<leader>g", ":Neogit<cr>", { silent = true })
    end,
  },

  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    config = function()
      require("bqf").setup {
        preview = {
          winblend = 0,
        },
      }
    end,
  },

  {
    "ellisonleao/gruvbox.nvim",
    priority = 200,
    config = function()
      require("gruvbox").setup {
        bold = false,
        override = {
          IlluminatedWordText = { gui = "undercurl" },
          IlluminatedWordRead   = { gui = "undercurl" },
          IlluminatedWordWrite = { gui = "undercurl" }
        }
      }

      vim.cmd [[
         hi! link NoiceCmdlinePopupBorder PopupBorder
      ]]
    end,
  },

  {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim"
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
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "yioneko/nvim-vtsls"
    },
    config = function()
      lsp_setup()
    end,
  },

  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup {
        suggestion = { enabled = false },
        panel = { enabled = false },
      }
    end,
  },

  {
    "zbirenbaum/copilot-cmp",
    dependencies = { "copilot.lua" },
    config = function()
      require("copilot_cmp").setup {
        formatters = {
          insert_text = require("copilot_cmp.format").remove_existing,
        },
      }
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-emoji",
      "quangnguyen30192/cmp-nvim-tags",
      "saadparwaiz1/cmp_luasnip",
      "onsails/lspkind-nvim",
    },
    config = function()
      cmp_setup()
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
      "windwp/nvim-ts-autotag",
      "RRethy/nvim-treesitter-endwise",
      "JoosepAlviste/nvim-ts-context-commentstring",
      "nvim-treesitter/playground",
    },
    config = function()
      treesitter_setup()
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    config = function()
      local ts_context = require "treesitter-context"
      ts_context.setup()

      vim.keymap.set("n", "[c", function()
        ts_context.go_to_context()
      end, { silent = true })
    end,
  },

  {
    "lewis6991/spellsitter.nvim",
    config = function()
      require("spellsitter").setup()
    end,
  },

  {
    "tpope/vim-projectionist",
    config = function()
      vim.keymap.set("n", "<leader>a", ":A<cr>", { silent = true })
    end,
  },

  "tpope/vim-eunuch",
  {
    "tamago324/lir.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim"
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
  },

  {
    "sickill/vim-pasta",
    config = function()
      vim.g.pasta_disabled_filetypes = { "coffee", "yaml", "haml" }
    end,
  },

  {
    "mileszs/ack.vim",
    config = function()
      vim.g.ackprg = "rg --vimgrep"
      vim.cmd "cabbrev ack LAck!"
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    config = function()
      lualine_setup()
    end,
  },

  {
    "b0o/incline.nvim",
    config = function()
      require("incline").setup {
        debounce_threshold = { falling = 500, rising = 250 },
        window = { padding = 0, margin = { horizontal = 0 } },
        hide = { focused_win = true },
      }
    end,
  },

  {
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
})

