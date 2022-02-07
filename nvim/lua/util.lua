local M = {}

function M.nmap(key, cmd)
  vim.api.nvim_set_keymap('n', key, cmd, { noremap = true, silent = true })
end

function M.vmap(key, cmd)
  vim.api.nvim_set_keymap('v', key, cmd, { noremap = true, silent = true  })
end

return M
