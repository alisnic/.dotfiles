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
  use "windwp/nvim-autopairs"
  use "tpope/vim-fugitive"
  use "tpope/vim-rhubarb"
  use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }
  use { "kevinhwang91/nvim-bqf", ft = "qf" }

  require("lsp_plugins").setup(use)
  require("autocomplete").setup(use)

  use "ellisonleao/gruvbox.nvim"

  use {
    "ishan9299/nvim-solarized-lua",
    config = function()
      vim.cmd "colorscheme gruvbox"
      vim.opt.background = "dark"
    end,
  }

  use { "windwp/nvim-ts-autotag" }
  use {
    "RRethy/nvim-treesitter-endwise",
    config = function()
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
    end,
  }

  use {
    "tpope/vim-projectionist",
    config = function()
      local util = require "util"
      local function runInTerminal(cmd)
        if vim.api.nvim_win_get_width(0) > 150 then
          vim.cmd("vsplit | term " .. cmd)
        else
          vim.cmd("tabedit | term " .. cmd)
        end

        vim.cmd "startinsert"
      end

      util.nmap("<leader>a", ":A<cr>")

      util.nmap_func("<leader>t", function()
        local prg = vim.api.nvim_buf_get_option(0, "makeprg")
        runInTerminal(prg)
      end)

      util.nmap_func("<leader>r", function()
        local prg = vim.api.nvim_buf_get_option(0, "makeprg")
        runInTerminal(prg .. " --only-failures --fail-fast")
      end)

      util.nmap_func("<leader>l", function()
        local prg = vim.api.nvim_buf_get_option(0, "makeprg")
        local line = vim.api.nvim_win_get_cursor(0)[1]

        runInTerminal(prg .. ":" .. line)
      end)
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
    "junegunn/fzf.vim",
    requires = { { "/opt/homebrew/opt/fzf" } },
    config = function()
      local util = require "util"
      util.nmap("<leader>f", ":Files<cr>")
      util.nmap("<leader>b", ":Buffers<cr>")
      util.nmap(
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

  -- use {
  --   "mfussenegger/nvim-dap",
  --   requires = {
  --     { "suketa/nvim-dap-ruby" },
  --   },
  --   config = function()
  --     local util = require "util"
  --
  --     util.nmap_func("<leader>B", function()
  --       require("dap").toggle_breakpoint()
  --     end)
  --
  --     require("dap-ruby").setup()
  --   end,
  -- }
  --
  if packer_bootstrap then
    require("packer").sync()
  end
end)
