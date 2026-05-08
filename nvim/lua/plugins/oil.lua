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
    keymaps = {
      ["q"] = "actions.close",
      ["gR"] = {
        callback = function()
          local oil = require("oil")
          local dir = oil.get_current_dir()
          local entry = oil.get_cursor_entry()

          if not dir or not entry then
            return
          end

          vim.system({ "open", "-R", dir .. entry.name }, { detach = true })
        end,
        desc = "Reveal in Finder",
      },
    },
  })

  vim.keymap.set("n", "-", "<cmd>Oil<cr>", { silent = true, desc = "Open Parent Directory" })
end

return M
