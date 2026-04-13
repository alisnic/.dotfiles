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
require("conform").setup({
  formatters_by_ft = {
    javascript = { "oxfmt" },
    javascriptreact = { "oxfmt" },
    typescript = { "oxfmt" },
    typescriptreact = { "oxfmt" },
    lua = { "stylua" },
  },
  formatters = {
    oxfmt = {
      args = function(_, ctx)
        local cfg = vim.fs.find(
          { ".oxfmtrc.json", ".oxfmtrc.jsonc" },
          { path = ctx.dirname, upward = true }
        )[1]
        if cfg then
          return { "--stdin-filepath", ctx.filename }
        end
        return {
          "--config",
          vim.fn.expand("~/.config/oxfmt/default.json"),
          "--stdin-filepath",
          ctx.filename,
        }
      end,
    },
    stylua = {
      prepend_args = {
        "--config-path",
        vim.fn.expand("~/.config/stylua.toml"),
      },
    },
  },
  format_after_save = {
    lsp_format = "fallback",
  },
})

add({ gh("nvim-tree/nvim-web-devicons") })
require("nvim-web-devicons").setup()

add({ gh("MunifTanjim/nui.nvim"), gh("folke/noice.nvim") })
require("noice").setup({
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
})

add({ gh("tpope/vim-unimpaired") })
vim.keymap.set("n", "[L", ":lolder<cr>", { silent = true })
vim.keymap.set("n", "]L", ":lnewer<cr>", { silent = true })
vim.keymap.set("n", "[Q", ":colder<cr>", { silent = true })
vim.keymap.set("n", "]Q", ":cnewer<cr>", { silent = true })

add({ gh("nvim-lua/plenary.nvim"), gh("nvim-telescope/telescope.nvim") })
local actions = require("telescope.actions")
require("telescope").setup({
  defaults = {
    layout_strategy = "vertical",
    layout_config = { width = 0.9, height = 0.9 },
    mappings = {
      i = {
        ["<esc>"] = actions.close,
      },
    },
  },
})
vim.keymap.set("n", "<leader>t", ":Telescope commands<cr>", { silent = true })
vim.keymap.set("n", "<leader>ld", ":Telescope diagnostics bufnr=0<cr>", { silent = true })
vim.keymap.set("n", "<leader>p", ":Telescope git_files show_untracked=true<cr>", { silent = true })
vim.keymap.set("n", "<leader>b", ":Telescope buffers sort_mru=true<cr>", { silent = true })
vim.keymap.set("n", "<leader>m", ":Telescope treesitter<cr>", { silent = true })
vim.keymap.set("n", "<leader>w", ":Telescope lsp_workspace_symbols query=")
vim.keymap.set("n", "<leader>h", ":Telescope help_tags<cr>", { silent = true })
vim.keymap.set("n", "<leader>d", ":Telescope diagnostics<cr>", { silent = true })

add({ gh("NeogitOrg/neogit") })
local neogit = require("neogit")
neogit.setup({
  disable_context_highlighting = true,
  disable_commit_confirmation = true,
  disable_signs = true,
  integrations = { telescope = true },
  process_spinner = true,
  auto_show_console = true,
  auto_show_console_on = "output",
  console_timeout = 200,
  auto_close_console = true,
  mappings = {
    popup = {
      ["Z"] = false,
    },
  },
})
vim.keymap.set("n", "gs", ":Neogit<cr>", { silent = true })

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
  gh("hrsh7th/cmp-cmdline"),
  gh("onsails/lspkind-nvim"),
})
require("autocomplete").setup()

add({ gh("JoosepAlviste/nvim-ts-context-commentstring") })
require("ts_context_commentstring").setup({
  enable_autocmd = false,
})
local get_option = vim.filetype.get_option
vim.filetype.get_option = function(filetype, option)
  return option == "commentstring"
      and require("ts_context_commentstring.internal").calculate_commentstring()
    or get_option(filetype, option)
end

add({
  gh("nvim-treesitter/nvim-treesitter"),
  gh("windwp/nvim-ts-autotag"),
  gh("RRethy/nvim-treesitter-endwise"),
})
require("nvim-ts-autotag").setup()
vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    pcall(vim.treesitter.start, args.buf)
    vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

add({ gh("nvim-treesitter/nvim-treesitter-context") })
local ts_context = require("treesitter-context")
ts_context.setup({ max_lines = 3 })
vim.keymap.set("n", "[c", function()
  ts_context.go_to_context()
end, { silent = true })

add({ gh("tamago324/lir.nvim") })
local lir_actions = require("lir.actions")
require("lir").setup({
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
      vim.cmd([[ !open % ]])
    end,
  },
})
vim.api.nvim_set_keymap("n", "-", [[<Cmd>execute 'e ' .. expand('%:p:h')<CR>]], { noremap = true })

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
  gh("folke/snacks.nvim"),
  gh("nickjvandyke/opencode.nvim"),
})

vim.o.autoread = true
local oc = require("opencode")

vim.keymap.set({ "n", "x" }, "<C-a>", function()
  oc.ask("@this: ", { submit = true })
end, { desc = "Ask opencode…" })

vim.keymap.set({ "n", "x" }, "<C-x>", function()
  oc.select()
end, { desc = "Execute opencode action…" })

vim.keymap.set({ "n" }, "<leader>i", function()
  local function find_oc_win()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if vim.bo[vim.api.nvim_win_get_buf(win)].buftype == "terminal" then
        return win
      end
    end
  end

  local cur_buf = vim.api.nvim_get_current_buf()
  if vim.bo[cur_buf].buftype == "terminal" then
    oc.toggle() -- hide
    return
  end

  local win = find_oc_win()
  if win then
    vim.api.nvim_set_current_win(win)
    vim.cmd("startinsert")
  else
    oc.toggle()
    vim.schedule(function()
      win = find_oc_win()
      if win then
        vim.api.nvim_set_current_win(win)
        vim.cmd("startinsert")
      end
    end)
  end
end, { desc = "Focus opencode" })

vim.keymap.set({ "n", "x" }, "go", function()
  return oc.operator("@this ")
end, { desc = "Add range to opencode", expr = true })

vim.keymap.set("n", "goo", function()
  return oc.operator("@this ") .. "_"
end, { desc = "Add line to opencode", expr = true })

vim.keymap.set("n", "<S-C-u>", function()
  oc.command("session.half.page.up")
end, { desc = "Scroll opencode up" })

vim.keymap.set("n", "<S-C-d>", function()
  oc.command("session.half.page.down")
end, { desc = "Scroll opencode down" })

add({
  gh("nvim-lualine/lualine.nvim"),
  gh("linrongbin16/lsp-progress.nvim"),
})
require("statusline").setup()
