local M = {}

function M.setup()
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
end

return M
