local gh = function(x)
  return "https://github.com/" .. x
end
local add = function(specs)
  vim.pack.add(specs, { confirm = false })
end

vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == "nvim-treesitter" and (kind == "install" or kind == "update") then
      if not ev.data.active then
        vim.cmd.packadd("nvim-treesitter")
      end
      vim.cmd("TSUpdate")
    end
  end,
})

-- automatically adjusts 'shiftwidth' and 'expandtab' heuristically
add({ gh("tpope/vim-sleuth") })

-- helpers for unix
add({ gh("tpope/vim-eunuch") })

add({ gh("michaeljsmith/vim-indent-object") })

add({ gh("stevearc/conform.nvim") })
require("plugins.conform").setup()

add({ gh("nvim-tree/nvim-web-devicons") })
require("nvim-web-devicons").setup()

add({ gh("MunifTanjim/nui.nvim"), gh("folke/noice.nvim") })
require("plugins.noice").setup()

add({ gh("tpope/vim-unimpaired") })
vim.keymap.set("n", "[L", ":lolder<cr>", { silent = true })
vim.keymap.set("n", "]L", ":lnewer<cr>", { silent = true })
vim.keymap.set("n", "[Q", ":colder<cr>", { silent = true })
vim.keymap.set("n", "]Q", ":cnewer<cr>", { silent = true })

add({ gh("nvim-lua/plenary.nvim"), gh("nvim-telescope/telescope.nvim") })
require("plugins.telescope").setup()

add({ gh("NeogitOrg/neogit") })
require("plugins.neogit").setup()

add({ gh("kevinhwang91/nvim-bqf") })
require("bqf").setup({
  preview = { winblend = 0 },
})

add({ gh("neovim/nvim-lspconfig") })
add({ gh("folke/lazydev.nvim") })
require("lazydev").setup({
  library = {
    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
  },
})

add({ gh("pmizio/typescript-tools.nvim") })
require("typescript-tools").setup({
  settings = {
    separate_diagnostic_server = false,
    tsserver_max_memory = 8192,
  },
})

add({
  gh("hrsh7th/nvim-cmp"),
  gh("hrsh7th/cmp-nvim-lsp"),
  gh("hrsh7th/cmp-buffer"),
  gh("hrsh7th/cmp-path"),
  gh("onsails/lspkind-nvim"),
})
require("autocomplete").setup()

add({
  gh("JoosepAlviste/nvim-ts-context-commentstring"),
  gh("nvim-treesitter/nvim-treesitter"),
  gh("windwp/nvim-ts-autotag"),
  gh("RRethy/nvim-treesitter-endwise"),
  gh("nvim-treesitter/nvim-treesitter-context"),
})
require("plugins.treesitter").setup()

add({ gh("tamago324/lir.nvim") })
require("plugins.lir").setup()

add({ gh("gmr458/vscode_modern_theme.nvim") })
require("vscode_modern").setup({
  cursorline = true,
  transparent_background = false,
})

add({ gh("lewis6991/gitsigns.nvim") })
require("gitsigns").setup()

add({ gh("sickill/vim-pasta") })
vim.g.pasta_disabled_filetypes = { "coffee", "yaml", "haml" }

add({ gh("mileszs/ack.vim") })
vim.g.ackprg = "rg --vimgrep -F"
vim.cmd("cabbrev ack Ack!")

add({
  gh("nvim-lualine/lualine.nvim"),
  gh("linrongbin16/lsp-progress.nvim"),
})
require("statusline").setup()
