local M = {}

function M.setup()
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
end

return M
