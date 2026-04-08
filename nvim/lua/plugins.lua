local gh = function(x) return 'https://github.com/' .. x end

vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == 'nvim-treesitter' and (kind == 'install' or kind == 'update') then
      if not ev.data.active then vim.cmd.packadd('nvim-treesitter') end
      vim.cmd('TSUpdate')
    end
  end,
})

-- automatically adjusts 'shiftwidth' and 'expandtab' heuristically
vim.pack.add({ gh 'tpope/vim-sleuth' })

-- helpers for unix
vim.pack.add({ gh 'tpope/vim-eunuch' })

vim.pack.add({ gh 'michaeljsmith/vim-indent-object' })

vim.pack.add({ gh 'lukas-reineke/lsp-format.nvim' })
require("lsp-format").setup {}

vim.pack.add({ gh 'nvim-tree/nvim-web-devicons' })
require("nvim-web-devicons").setup()

vim.pack.add({ gh 'MunifTanjim/nui.nvim', gh 'folke/noice.nvim' })
require("noice").setup {
  lsp = {
    signature = {
      enabled = true,
      auto_open = { enabled = false },
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

vim.pack.add({ gh 'tpope/vim-unimpaired' })
vim.keymap.set("n", "[L", ":lolder<cr>", { silent = true })
vim.keymap.set("n", "]L", ":lnewer<cr>", { silent = true })
vim.keymap.set("n", "[Q", ":colder<cr>", { silent = true })
vim.keymap.set("n", "]Q", ":cnewer<cr>", { silent = true })

vim.pack.add({ gh 'nvim-lua/plenary.nvim', gh 'nvim-telescope/telescope.nvim' })
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
vim.keymap.set("n", "<leader>t", ":Telescope commands<cr>", { silent = true })
vim.keymap.set("n", "<leader>ld", ":Telescope diagnostics bufnr=0<cr>", { silent = true })
vim.keymap.set("n", "<leader>p", ":Telescope find_files hidden=true<cr>", { silent = true })
vim.keymap.set("n", "<leader>b", ":Telescope buffers sort_mru=true<cr>", { silent = true })
vim.keymap.set("n", "<leader>m", ":Telescope treesitter<cr>", { silent = true })
vim.keymap.set("n", "<leader>w", ":Telescope lsp_workspace_symbols query=")
vim.keymap.set("n", "<leader>h", ":Telescope help_tags<cr>", { silent = true })

vim.pack.add({ gh 'NeogitOrg/neogit' })
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

vim.pack.add({ gh 'kevinhwang91/nvim-bqf' })
require("bqf").setup {
  preview = { winblend = 0 },
}

vim.pack.add({ gh 'nvimtools/none-ls.nvim' })

vim.pack.add({ gh 'neovim/nvim-lspconfig' })

vim.pack.add({
  gh 'hrsh7th/nvim-cmp',
  gh 'hrsh7th/cmp-nvim-lsp',
  gh 'hrsh7th/cmp-buffer',
  gh 'hrsh7th/cmp-path',
  gh 'hrsh7th/cmp-cmdline',
  gh 'onsails/lspkind-nvim',
})
require("autocomplete").setup()

vim.pack.add({ gh 'JoosepAlviste/nvim-ts-context-commentstring' })
require("ts_context_commentstring").setup {
  enable_autocmd = false,
}
local get_option = vim.filetype.get_option
vim.filetype.get_option = function(filetype, option)
  return option == "commentstring"
      and require("ts_context_commentstring.internal").calculate_commentstring()
    or get_option(filetype, option)
end

vim.pack.add({
  gh 'nvim-treesitter/nvim-treesitter',
  gh 'windwp/nvim-ts-autotag',
  gh 'RRethy/nvim-treesitter-endwise',
})
require("nvim-treesitter.configs").setup {
  highlight = { enable = true },
  endwise = { enable = true },
  indent = { enable = true },
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

vim.pack.add({ gh 'nvim-treesitter/nvim-treesitter-context' })
local ts_context = require "treesitter-context"
ts_context.setup { max_lines = 3 }
vim.keymap.set("n", "[c", function()
  ts_context.go_to_context()
end, { silent = true })

vim.pack.add({ gh 'tamago324/lir.nvim' })
local lir_actions = require "lir.actions"
require("lir").setup {
  show_hidden_files = true,
  devicons = {
    enable = true,
    highlight_dirname = false,
  },
  mappings = {
    ["<cr>"] = lir_actions.edit,
    ["<C-s>"] = lir_actions.split,
    ["<C-v>"] = lir_actions.vsplit,
    ["<C-t>"] = lir_actions.tabedit,
    ["-"] = lir_actions.up,
    ["q"] = lir_actions.quit,
    ["K"] = lir_actions.mkdir,
    ["N"] = lir_actions.newfile,
    ["R"] = lir_actions.rename,
    ["Y"] = lir_actions.yank_path,
    ["."] = lir_actions.toggle_show_hidden,
    ["D"] = lir_actions.delete,
    ["o"] = function()
      vim.cmd [[ !open % ]]
    end,
  },
}
vim.api.nvim_set_keymap("n", "-", [[<Cmd>execute 'e ' .. expand('%:p:h')<CR>]], { noremap = true })

vim.pack.add({ gh 'sickill/vim-pasta' })
vim.g.pasta_disabled_filetypes = { "coffee", "yaml", "haml" }

vim.pack.add({ gh 'mileszs/ack.vim' })
vim.g.ackprg = "rg --vimgrep -F"
vim.cmd "cabbrev ack Ack!"
