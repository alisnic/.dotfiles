local M = {}

function M.setup()
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
end

return M
