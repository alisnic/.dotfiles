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

  -- automatically adjusts 'shiftwidth' and 'expandtab' heuristically based on the current file
  use "tpope/vim-sleuth"

  -- GBrowse integration for file
  -- use "tpope/vim-rhubarb"

  -- Helpers for unix
  use "tpope/vim-eunuch"

  use "google/vim-searchindex"
  use "folke/neodev.nvim"
  use "michaeljsmith/vim-indent-object"

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
    "nvim-tree/nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").setup()
    end,
  }

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
          progress = { enabled = false },
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
            },
          },
        },
      }

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
        ":Telescope lsp_workspace_symbols query="
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
    "NeogitOrg/neogit",
    config = function()
      local neogit = require "neogit"
      neogit.setup {
        disable_context_highlighting = true,
        disable_commit_confirmation = true,
        disable_signs = true,
        integrations = { telescope = true },
        auto_show_console = false,
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
    "jose-elias-alvarez/null-ls.nvim",
    requires = {
      { "nvim-lua/plenary.nvim" },
    },
  }

  use {
    "neovim/nvim-lspconfig"
  }

  use {
    "hrsh7th/nvim-cmp",
    requires = {
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-cmdline" },
      -- { "saadparwaiz1/cmp_luasnip" },
      { "onsails/lspkind-nvim" },
    },
    config = function()
      require("autocomplete").setup()
    end,
  }

  use {
    "JoosepAlviste/nvim-ts-context-commentstring",
    config = function()
      require("ts_context_commentstring").setup {
        enable_autocmd = false,
      }

      local get_option = vim.filetype.get_option

      vim.filetype.get_option = function(filetype, option)
        return option == "commentstring"
            and require("ts_context_commentstring.internal").calculate_commentstring()
          or get_option(filetype, option)
      end
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
    requires = {
      { "linrongbin16/lsp-progress.nvim" },
    },
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

  if packer_bootstrap then
    require("packer").sync()
  end
end)

function treesitter_setup()
  require("nvim-treesitter.configs").setup {
    highlight = { enable = true },
    endwise = {
      enable = true,
    },
    indent = {
      enable = true,
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        node_incremental = "v",
        node_decremental = "V",
      },
    },
    autotag = {
      enable = true,
      filetypes = { "html", "eruby", "javascriptreact", "typescriptreact" },
    },
  }
end
