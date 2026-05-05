local M = {}

function M.setup()
  require("oil").setup({
    default_file_explorer = true,
    columns = { "icon" },
    view_options = {
      show_hidden = true,
    },
    lsp_file_methods = {
      enabled = true,
      timeout_ms = 1000,
      autosave_changes = "unmodified",
    },
  })

  vim.keymap.set("n", "-", "<cmd>Oil<cr>", { silent = true, desc = "Open Parent Directory" })
end

return M
